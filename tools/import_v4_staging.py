"""Import an unchanged official workbook into private raw staging, never production.

Usage: python3 tools/import_v4_staging.py /absolute/path/to/workbook.xlsx
Requires openpyxl; MYSQL_HOST/PORT/USER configure the isolated MySQL connection.
CSV/SQL exports stay in the ignored database/local/v4 directory.
"""
from pathlib import Path
import argparse,csv,datetime,hashlib,json,os,shutil,subprocess
import openpyxl

ROOT=Path(__file__).resolve().parents[1]
EXPECTED_SHA='88362589a519b6f9aeae031fe806bcf85f0d8b513c12b11f6a4e619ee855c4ac'

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('workbook',type=Path)
    args=parser.parse_args()
    digest=hashlib.sha256(args.workbook.read_bytes()).hexdigest()
    if digest!=EXPECTED_SHA:
        raise SystemExit('Workbook SHA differs from the frozen v4 source; review before import.')
    workbook=openpyxl.load_workbook(args.workbook,data_only=True)
    private=ROOT/'database/local/v4'; private.mkdir(parents=True,exist_ok=True)
    mysql=[os.getenv('MYSQL') or shutil.which('mysql') or 'mysql',
           '-h'+os.getenv('MYSQL_HOST','127.0.0.1'),'-P'+os.getenv('MYSQL_PORT','3306'),
           '-u'+os.getenv('MYSQL_USER','root'),'--default-character-set=utf8mb4','--batch','--raw']
    def run(sql):
        result=subprocess.run(mysql,input=sql,text=True,capture_output=True)
        if result.returncode: raise RuntimeError(result.stderr)
        return result.stdout
    def value(v):
        if isinstance(v,datetime.datetime): return v.strftime('%Y-%m-%d')
        if isinstance(v,datetime.time): return v.strftime('%H:%M:%S')
        return None if v is None else str(v)
    def sqlvalue(v):
        return 'NULL' if v is None else 'CONVERT(0x'+str(v).encode('utf8').hex()+' USING utf8mb4)'
    specs=[('orders','stg_v4_orders',12,'ORD',182),
           ('starting address set','stg_v4_starting_address',6,'ADDR',102),
           ('customer and address history','stg_v4_customer_address_history',18,'CUST',53)]
    imports=[]
    for sheet,table,width,prefix,expected in specs:
        rows=[[i]+[value(v) for v in row[:width]] for i,row in enumerate(workbook[sheet].values,1)
              if i>1 and isinstance(row[0],str) and row[0].startswith(prefix)]
        if len(rows)!=expected: raise SystemExit(f'{sheet}: expected {expected} business rows, found {len(rows)}')
        imports.append((sheet,table,rows))
    # Validate all source counts before any staging mutation.
    run((ROOT/'database/cleaning/01_v4_staging.sql').read_text())
    for sheet,table,rows in imports:
        with (private/(table+'.csv')).open('w',newline='',encoding='utf8') as f:
            csv.writer(f).writerows(rows)
        sql='USE cloudreststaging;\nINSERT INTO '+table+' VALUES\n'+',\n'.join(
            '('+','.join(sqlvalue(v) for v in row)+')' for row in rows)+';'
        (private/(table+'.sql')).write_text(sql,encoding='utf8')
        run(sql)
    (private/'raw-profile.tsv').write_text(run((ROOT/'database/cleaning/02_v4_profile_and_clean.sql').read_text()),encoding='utf8')
    print(json.dumps({'sha256':digest,'rows':{sheet:len(rows) for sheet,table,rows in imports},
                      'productionImport':'NONE; ambiguous business dispositions remain unresolved'},indent=2))

if __name__=='__main__': main()
