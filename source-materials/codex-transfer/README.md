# Temporary Codex source-file transfer

This branch exists only to transfer the official A2 v4 workbook to the local Codex checkout without adding the binary workbook to PR #2.

Workbook:
- original name: BISM2207 A2 Sem 2 2026 Data v4(1).xlsx
- size: 32,969 bytes
- SHA-256: 88362589a519b6f9aeae031fe806bcf85f0d8b513c12b11f6a4e619ee855c4ac

The workbook is stored as four base64 text parts under:
source-materials/codex-transfer/workbook/

From the local repository, while remaining on revision/tutor-feedback-v4-20261007:

git fetch origin codex/source-materials-temp-20261007

python3 - <<'PY'
import base64, subprocess, pathlib
branch='origin/codex/source-materials-temp-20261007'
parts=[
 'source-materials/codex-transfer/workbook/part00.b64',
 'source-materials/codex-transfer/workbook/part01.b64',
 'source-materials/codex-transfer/workbook/part02.b64',
 'source-materials/codex-transfer/workbook/part03.b64',
]
data=''.join(subprocess.check_output(['git','show',f'{branch}:{p}'], text=True).strip() for p in parts)
out=pathlib.Path('/tmp/BISM2207_A2_Sem_2_2026_Data_v4.xlsx')
out.write_bytes(base64.b64decode(data))
print(out)
PY

Verify:

shasum -a 256 /tmp/BISM2207_A2_Sem_2_2026_Data_v4.xlsx

Expected:
88362589a519b6f9aeae031fe806bcf85f0d8b513c12b11f6a4e619ee855c4ac

Do not merge this temporary transfer branch into main or PR #2. The assessment workbook should remain outside the public submission branch.
