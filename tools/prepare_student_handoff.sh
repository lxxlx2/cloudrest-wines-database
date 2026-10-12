#!/usr/bin/env bash
set -euo pipefail
REPO="${1:-$HOME/Documents/ChatGPT/cloudrest-wines-database}"
BRANCH="revision/tutor-feedback-v4-20261007"
ROOT="$(cd "$REPO" && pwd)"
cd "$ROOT"
[[ "$(git branch --show-current)" == "$BRANCH" ]] || { echo "ERROR: checkout $BRANCH first"; exit 1; }
git fetch origin "$BRANCH"
[[ "$(git rev-parse HEAD)" == "$(git rev-parse FETCH_HEAD)" ]] || { echo "ERROR: local checkout is not at the latest remote HEAD; run git pull --ff-only"; exit 1; }
HEAD="$(git rev-parse HEAD)"
FILES=(
  Cloudrest_Wines_Report.docx
  Cloudrest_Wines_Database.sql
  Cloudrest_Wines_Queries.sql
  Cloudrest_Wines_Rule_Violations.sql
  Cloudrest_Wines_Model.mwb
)
for name in "${FILES[@]}"; do
  rel="deliverables/final-submission/$name"
  [[ -f "$rel" ]] || { echo "ERROR: missing $rel"; exit 1; }
  [[ "$(git hash-object "$rel")" == "$(git rev-parse "HEAD:$rel")" ]] || { echo "ERROR: not the final committed version: $rel"; exit 1; }
done
OUT="$HOME/Downloads/Cloudrest_Wines_Student_Handoff"
mkdir -p "$OUT"
rm -f "$OUT"/*
for name in "${FILES[@]}"; do cp "deliverables/final-submission/$name" "$OUT/$name"; done
cp docs/video/five-minute-script.md "$OUT/Video_Script.md"
cp docs/ai/ripple-reflection.md "$OUT/AI_Reflection.md"
cat > "$OUT/READ_ME_交付说明.txt" <<EOF
Cloudrest Wines — BISM2207 handoff
Git branch: $BRANCH
Git commit: $HEAD

Main project outputs:
Cloudrest_Wines_Report.docx
Cloudrest_Wines_Database.sql
Cloudrest_Wines_Queries.sql
Cloudrest_Wines_Rule_Violations.sql
Cloudrest_Wines_Model.mwb

Important: Final ER screenshots (complete UML and six domain diagrams) must be exported by the students from the INCLUDED updated .mwb. Old ER PNG files were intentionally excluded because they predate Hint 8. The report contains explicit ER screenshot replacement slots. Replace those slots in Word using the new Workbench exports, then inspect formatting and save the report again.

Students also capture any Workbench proof/screenshots required by their course and confirm submission dates and individual contributions. The separate video, RiPPlE and peer-review activities remain their responsibility.
The six decision-support queries use synthetic HR test records; supplied A2 v4 data is separately imported and audited.

Suggested responsibilities:
Zixuan Shen — final report, project plan/risk, overall submission check
Feiyue Ma — Workbench EER UML model, updated ER screenshots, data dictionary
Xinzhu Wang — SQL/integrity, A2 v4 cleaning, import and Task 6 screenshots
Chengye Jiang — six queries, procedure, EXPLAIN and video demonstration

AI_Reflection.md is a project-based draft, NOT a certified original chat transcript or completed peer reviews; students confirm accurate personal details and submit genuine course interactions.
EOF
cat > "$OUT/VERIFIED_GIT_COMMIT.txt" <<EOF
$HEAD
EOF
if command -v shasum >/dev/null; then (cd "$OUT" && shasum -a 256 "${FILES[@]}") > "$OUT/SHA256.txt"; fi
ZIP="$HOME/Downloads/Cloudrest_Wines_Student_Handoff.zip"
rm -f "$ZIP"
(cd "$HOME/Downloads" && /usr/bin/zip -q -r "$ZIP" Cloudrest_Wines_Student_Handoff)
echo "GIT_HEAD=$HEAD"
echo "DELIVERY_ZIP=$ZIP"
echo "DELIVERY_FOLDER=$OUT"
echo "NOTE: fresh ER captures must replace report placeholders; old PNGs excluded."
