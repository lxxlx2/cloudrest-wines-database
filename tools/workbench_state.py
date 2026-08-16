import grt
from pathlib import Path

out=[]
out.append('before doc='+repr(getattr(grt.root.wb,'doc',None)))
try:
    result=grt.modules.Workbench.newDocument()
    out.append('newDocument result='+repr(result))
except Exception as e:
    out.append('newDocument error='+repr(e))
doc=getattr(grt.root.wb,'doc',None)
out.append('after doc='+repr(doc))
if doc:
    out.append('doc members='+repr(getattr(doc,'__members__',None)))
    out.append('physicalModels='+repr(doc.physicalModels))
    if doc.physicalModels:
        m=doc.physicalModels[0]
        out.append('model='+repr(m))
        out.append('model members='+repr(getattr(m,'__grtmembers__',None)))
        out.append('catalog='+repr(m.catalog))
        out.append('catalog members='+repr(getattr(m.catalog,'__grtmembers__',None)))
        for name in ['characterSets','version','schemata','simpleDatatypes']:
            try: out.append(name+'='+repr(getattr(m.catalog,name)))
            except Exception as e: out.append(name+' error='+repr(e))
Path('/tmp/workbench_state.txt').write_text('\n'.join(out),encoding='utf-8')
