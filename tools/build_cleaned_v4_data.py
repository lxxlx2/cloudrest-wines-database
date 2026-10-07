"""Build the bounded official-v4 import and row dispositions from private staging CSVs.
Run import_v4_staging.py first. Source contact exports remain private; this writes
normalised accepted INSERTs and an ID-only disposition ledger for the assignment.
"""
from pathlib import Path
from collections import defaultdict,Counter
from decimal import Decimal
import csv,json,re
ROOT=Path(__file__).resolve().parents[1]
PRIVATE=ROOT/'database/local/v4'
def load(name):
 with (PRIVATE/(name+'.csv')).open(encoding='utf8',newline='') as f:
  return [[None if x=='' else x for x in r] for r in csv.reader(f)]
def norm(s): return re.sub(r'\s+',' ',s.strip()) if s else None
def val(x):
 if x is None:return 'NULL'
 if isinstance(x,(int,Decimal)):return str(x)
 return "'"+str(x).replace('\\','\\\\').replace("'","''")+"'"
def ident(s,prefix):return prefix+str(int(re.search(r'\d+$',s).group())).zfill(3)
def main():
 orders=load('stg_v4_orders');addresses=load('stg_v4_starting_address');history=load('stg_v4_customer_address_history')
 customers={}
 for r in sorted(history,key=lambda r:(r[3],r[4])):customers.setdefault(r[1],r)
 assert len(customers)==50
 table=defaultdict(list);parts=['-- Accepted cleaned supplied v4 data plus explicitly labelled supplemental test attributes.\n-- Raw workbook/contact exports are not included. See docs/report/task6-data-quality.md.\nUSE cloudrestwines;\nSTART TRANSACTION;\n']
 def emit(name,cols,rows,label='Cleaned supplied fields'):
  if not rows:return
  table[name]+=rows
  parts.append('\n-- '+label+'\nINSERT INTO '+name+' ('+','.join(cols)+') VALUES\n'+',\n'.join('('+','.join(val(v) for v in row)+')' for row in rows)+';\n')
 emit('customer',['customerId','customerType','emailAddress','isActive'],[(ident(c,'VCUS'),r[9].upper(),r[15],1) for c,r in sorted(customers.items())], 'Source Customer Id maps one-to-one to VCUS###; isActive=1 is an import-state assumption, not a source assertion.')
 emit('individualcustomer',['customerId','firstName','lastName','dateOfBirth'],[(ident(c,'VCUS'),r[12],r[13],r[14]) for c,r in sorted(customers.items()) if r[9]=='individual'])
 emit('businesscustomer',['customerId','companyName','australianBusinessNumber','contactFirstName','contactLastName','businessType'],[(ident(c,'VCUS'),norm(r[10]),r[11],r[12],r[13],'OTHER') for c,r in sorted(customers.items()) if r[9]=='business'], 'Business subtype is not supplied: OTHER denotes unspecified, without guessing restaurant/shop/export type.')
 ar=[]
 for r in addresses:
  full=r[6].replace('â€“','–');m=re.fullmatch(r'(.*),\s*(.+?)\s+(ACT|NSW|NT|QLD|SA|TAS|VIC|WA)\s+(\d{4})',full);assert m,r[1]
  street,city,state,postcode=m.groups();unit=norm(r[2]);level=norm(r[3])
  # A repeated unit prefix in Full Address is redundant with its structured source column.
  if ',' in street:
   prefix,street=street.split(',',1);assert norm(prefix)==unit,(r[1],prefix,unit);street=street.strip()
  sm=re.fullmatch(r'([0-9]+(?:[A-Za-z]|[–-][0-9]+[A-Za-z]?)?)\s+(.+)',street);assert sm,r[1]
  def split(s):
   if not s:return (None,None)
   q=re.fullmatch(r'(.+?)\s+([0-9]+[A-Za-z]?)',s);assert q,s;return q.groups()
  ut,un=split(unit);lt,ln=split(level)
  ar.append(('VADR'+str(int(r[1][4:])).zfill(4),'PHYSICAL',None,ut,un,lt,ln,r[4],r[5],sm[1],sm[2],city,state,postcode))
 emit('address',['addressId','addressKind','postalType','unitType','unitNumber','levelType','levelNumber','buildingName','placeName','addressNumber','streetName','locality','stateCode','postcode'],ar,'Keep each source Address Id separately; no canonical merge. Structured Unit/Level fields distinguish same-string addresses. All source full addresses parse as physical street addresses.')
 hist=[]
 for r in history:
  start=r[3]+' '+r[4];end=r[5]+' '+r[6] if r[5] else None
  hist.append((ident(r[1],'VCUS'),'VADR'+str(int(r[2][4:])).zfill(4),r[7].upper(),start,end))
 emit('customeraddress',['customerId','addressId','addressPurpose','startDateTime','endDateTime'],hist,'Source dates/times retained exactly, including export-reset values; no lost original date reconstructed.')
 phones=defaultdict(set)
 for c,r in customers.items():
  for p in r[16:19]:
   if p:phones[norm(p)].add(c)
 shared={p for p,c in phones.items() if len(c)>1};unique=sorted(set(phones)-shared)
 phonemap={p:'VP'+str(i).zfill(6) for i,p in enumerate(unique,1)}
 emit('phone',['phoneId','countryCode','phoneNumber','phoneType'],[(phonemap[p],'+61',p,'OTHER') for p in unique], 'AU country code +61 is a documented address-country import assumption; source number retained, OTHER means type unspecified. Shared values quarantined.')
 cp=[];phoneheld=[]
 for c,r in sorted(customers.items()):
  for slot,p in enumerate(r[16:19],1):
   if not p:continue
   p=norm(p)
   if p in shared:phoneheld.append((c,slot,'SHARED_PHONE_VALUE'))
   else:cp.append((ident(c,'VCUS'),phonemap[p],r[3]+' '+r[4],None,0))
 emit('customerphone',['customerId','phoneId','startDateTime','endDateTime','isPrimary'],cp,'Phone effective start uses the earliest supplied customer-history start as an explicit import assumption; no primary phone rank supplied, so all isPrimary=FALSE. No shared value is assigned to a customer.')
 # Missing mandatory wine/product attributes are added test data, never claimed as workbook facts.
 products={r[4]:r[5].replace('RosÃ©','Rosé') for r in orders};assert len(products)==10
 emit('winecategory',['wineCategoryId','categoryName'],[('CTV4','V4 supplemental test category')],'SUPPLEMENTAL TEST DATA: required category is not supplied.')
 wines=[];recipes=[];prods=[]
 for p,name in sorted(products.items()):
  wid=ident(p,'VW00');wines.append((wid,name,2026,'CTV4',13.5,'EMP0004'));recipes.append((wid,'GRAPE01',100));prods.append((ident(p,'VPRD'),wid,'BOTL001',12,1))
 emit('wine',['wineId','wineName','vintageYear','wineCategoryId','alcoholPercent','winemakerId'],wines,'Source wineName retained; vintage 2026, category, 13.5% alcohol and synthetic winemaker are SUPPLEMENTAL TEST ATTRIBUTES, not inferred source facts.')
 emit('winecomposition',['wineId','grapeVarietyId','proportionPercent'],recipes,'SUPPLEMENTAL TEST RECIPE: 100% existing GRAPE01 enables integrity testing; not a factual recipe for these named wines.')
 emit('wineproduct',['productId','wineId','bottleTypeId','caseQuantity','isActive'],prods,'Source Product Id maps one-to-one to VPRD###; bottle BOTL001 / 12 bottles per case / active state are SUPPLEMENTAL TEST ATTRIBUTES.')
 exact=set();first={};clean=[]
 for r in orders:
  key=tuple(r[1:])
  if key in first:exact.add(int(r[0]));continue
  first[key]=r[0];r=r.copy();r[2]=re.sub(' ','',r[2].strip()).upper();r[5]=r[5].replace('RosÃ©','Rosé');clean.append(r)
 pair=Counter((r[1],r[4]) for r in clean);ambiguous={k for k,v in pair.items() if v>1};byorder=defaultdict(list)
 for r in clean:byorder[r[1]].append(r)
 ledger=[];accepted=[];heldfacts=[]
 for oid,rows in sorted(byorder.items()):
  reasons=[]
  if any((r[1],r[4]) in ambiguous for r in rows):reasons.append('ORDER_CONTAINS_AMBIGUOUS_PAIR')
  if len({r[11] for r in rows})>1 or len({r[12] for r in rows})>1:reasons.append('MIXED_ORDER_STATUS')
  if any(r[11] not in ('shipped','pending') for r in rows):reasons.append('UNREPRESENTABLE_SHIPMENT_STATUS')
  if any(r[12] not in ('paid',None) for r in rows):reasons.append('UNREPRESENTABLE_PAYMENT_STATUS')
  assert len({(r[2],r[3]) for r in rows})==1
  for r in rows:
   direct=(r[1],r[4]) in ambiguous
   disposition='QUARANTINED_AMBIGUOUS_PAIR' if direct else 'QUARANTINED_OTHER' if reasons else 'IMPORTED'
   ledger.append((int(r[0]),oid,r[4],disposition,';'.join(reasons) if reasons else 'UNIQUE_LINE_AND_CONSISTENT_HEADER'))
   if not reasons:accepted.append(r)
  if not reasons and rows[0][11]=='shipped':heldfacts.append((oid,'SHIPMENT_DETAIL','DATE_AND_DELIVERY_ADDRESS_NOT_SUPPLIED'))
 # Headers only for wholly accepted orders, preventing partial-order totals/status implications.
 acceptedorders=sorted({r[1] for r in accepted});heads=[]
 for oid in acceptedorders:
  r=byorder[oid][0];heads.append((ident(oid,'VORD'),ident(r[2],'VCUS'),r[3],int(r[12]=='paid'),r[11].upper()))
 emit('customerorder',['customerOrderId','customerId','receivedDate','paidFlag','orderStatus'],heads,'Only complete accepted orders. Blank payment -> paidFlag FALSE means no confirmed payment; shipped/pending map directly. No invented shipment date/address.')
 emit('orderline',['customerOrderId','productId','caseQuantity','agreedCasePrice'],[(ident(r[1],'VORD'),ident(r[4],'VPRD'),int(r[6]),Decimal(r[7])) for r in accepted],'Accepted source line quantity and agreed price; no summing or price averaging.')
 for n in exact:
  r=next(r for r in orders if int(r[0])==n);ledger.append((n,r[1],r[4],'REJECTED_EXACT_COPY','IDENTICAL_ALL_SOURCE_FIELDS_KEEP_EARLIEST_ROW'))
 parts.append('\nCOMMIT;\n')
 (ROOT/'database/data/02_cleaned_v4_data.sql').write_text(''.join(parts),encoding='utf8')
 with (ROOT/'docs/evidence/v4-import-dispositions.csv').open('w',encoding='utf8',newline='') as f:
  w=csv.writer(f);w.writerow(['sourceRowNumber','orderId','productId','disposition','reason']);w.writerows(sorted(ledger))
 with (ROOT/'docs/evidence/v4-dependent-facts-quarantine.csv').open('w',encoding='utf8',newline='') as f:
  w=csv.writer(f);w.writerow(['sourceId','factOrSlot','reason']);w.writerows(heldfacts+phoneheld)
 counts=Counter(r[3] for r in ledger)
 summary={'sourceOrderRows':len(orders),'acceptedImportedOrderRows':counts['IMPORTED'],'exactDuplicatesRejected':len(exact),'ambiguousPairRowsQuarantined':counts['QUARANTINED_AMBIGUOUS_PAIR'],'otherOrderRowsQuarantined':counts['QUARANTINED_OTHER'],'acceptedOrders':len(heads),'tablesImported':{t:len(v) for t,v in table.items()},'sharedPhoneGroupsQuarantined':len(shared),'phoneAssociationsQuarantined':len(phoneheld),'shipmentDetailsQuarantined':len(heldfacts),'productionImport':'CLEANED SUPPLIED DATA AND SUPPLEMENTAL TEST DATA','reconciliation':'COMPLETE: all 182 source order rows have exactly one disposition; quarantines retained in private staging','reasonOrderCounts':dict(Counter(reason for rows in byorder.values() for reason in ([('AMBIGUOUS_PAIR')] if any((r[1],r[4]) in ambiguous for r in rows) else [])))}
 assert sum(counts.values())==182
 (PRIVATE/'import-summary.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps(summary,indent=2))
if __name__=='__main__':main()
