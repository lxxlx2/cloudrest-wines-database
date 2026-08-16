import grt
from pathlib import Path

out = Path('/tmp/workbench_modules.txt')
lines = []
for module_name in ['Workbench', 'WbModel', 'MySQLParserServices', 'DbMySQLRE']:
    module = getattr(grt.modules, module_name, None)
    lines.append(f'[{module_name}]')
    lines.append(repr(module))
    if module:
        for attr in ['__dict__', '__members__', '__methods__']:
            try:
                lines.append(f'{attr}={getattr(module, attr)}')
            except Exception as exc:
                lines.append(f'{attr}=ERROR {exc}')
try:
    lines.append('[registry modules]')
    for module in grt.root.wb.registry.modules:
        lines.append(f'{module.name}: ' + ','.join(f.name for f in module.functions))
except Exception as exc:
    lines.append(f'registry ERROR {exc}')
for module_name, methods in {
    'Workbench':['newDocument','saveModelAs','newDiagram','exportDiagramToPng'],
    'WbModel':['createDiagramWithCatalog','autolayout'],
    'MySQLParserServices':['createNewParserContext','parseSQLIntoCatalogSql'],
}.items():
    module = getattr(grt.modules,module_name)
    for method in methods:
        fn = getattr(module,method)
        lines.append(f'[signature {module_name}.{method}] repr={fn!r} doc={getattr(fn,"__doc__",None)!r}')
out.write_text('\n'.join(lines), encoding='utf-8')
