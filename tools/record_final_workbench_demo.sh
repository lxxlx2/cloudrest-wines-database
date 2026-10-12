#!/usr/bin/env bash
set -euo pipefail
BRANCH="revision/tutor-feedback-v4-20261007"
REPO="${1:-$HOME/Documents/ChatGPT/cloudrest-wines-database}"
cd "$REPO"
die(){ printf 'ERROR: %s\n' "$*" >&2; exit 1; }
[[ "$(uname -s)" == "Darwin" ]] || die "This recorder requires macOS."
[[ "$(git branch --show-current)" == "$BRANCH" ]] || die "Switch to $BRANCH first."
command -v ffmpeg >/dev/null || die "Run brew install ffmpeg"
command -v ffprobe >/dev/null || die "Run brew install ffmpeg"
command -v osascript >/dev/null || die "Missing AppleScript"
command -v pbcopy >/dev/null || die "Missing pbcopy"
command -v python3 >/dev/null || die "Missing python3"
git fetch -q origin "$BRANCH"
HEAD="$(git rev-parse HEAD)"
[[ "$HEAD" == "$(git rev-parse FETCH_HEAD)" ]] || die "Local branch is behind remote. Run git pull --ff-only."
for f in Cloudrest_Wines_Database.sql Cloudrest_Wines_Queries.sql Cloudrest_Wines_Model.mwb; do
 p="deliverables/final-submission/$f"
 [[ -f "$p" ]] || die "Missing $p"
 [[ "$(git hash-object "$p")" == "$(git rev-parse "HEAD:$p")" ]] || die "Not the committed final version: $p"
done
for f in database/queries/0*.sql; do
 [[ "$(git hash-object "$f")" == "$(git rev-parse "HEAD:$f")" ]] || die "Query differs from the final commit: $f"
done
echo "VERIFIED_GIT_HEAD=$HEAD"
echo "WORKBENCH_MODEL=deliverables/final-submission/Cloudrest_Wines_Model.mwb"
TMP="$(mktemp -d /tmp/cloudrest-record.XXXXXX)"
REC_PID=""
cleanup(){
 if [[ -n "$REC_PID" ]] && kill -0 "$REC_PID" 2>/dev/null; then
  kill -INT "$REC_PID" 2>/dev/null || true
  wait "$REC_PID" 2>/dev/null || true
 fi
 rm -rf "$TMP"
}
trap cleanup EXIT
MYSQL="${MYSQL_CLI:-$(command -v mysql || true)}"
if [[ -z "$MYSQL" && -x /opt/homebrew/opt/mysql@8.4/bin/mysql ]]; then MYSQL=/opt/homebrew/opt/mysql@8.4/bin/mysql; fi
[[ -n "$MYSQL" ]] || die "MySQL CLI not found. Install mysql-client or supply MYSQL_CLI."
CONN=( "$MYSQL" "-h${MYSQL_HOST:-127.0.0.1}" "-P${MYSQL_PORT:-3306}" "-u${MYSQL_USER:-root}" "--batch" "--skip-column-names" )
if [[ -n "${MYSQL_LOGIN_PATH:-}" ]]; then
 CONN=( "$MYSQL" "--login-path=$MYSQL_LOGIN_PATH" "-h${MYSQL_HOST:-127.0.0.1}" "-P${MYSQL_PORT:-3306}" "--batch" "--skip-column-names" )
fi
METRICS="$("${CONN[@]}" -e "SELECT
 (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='cloudrestwines' AND table_type='BASE TABLE'),
 (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema='cloudrestwines'),
 (SELECT COUNT(*) FROM information_schema.referential_constraints WHERE constraint_schema='cloudrestwines'),
 (SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema='cloudrestwines' AND constraint_type='CHECK'),
 (SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_schema='cloudrestwines'),
 (SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema='cloudrestwines'),
 (SELECT COUNT(*) FROM cloudrestwines.orderline WHERE customerOrderId LIKE 'VORD%')" 2>"$TMP/mysql-error.log")" || {
 cat "$TMP/mysql-error.log" >&2
 die "MySQL CLI connection failed. Resolve credentials/server and retry; no recording made."
}
read -r N_TABLE N_COL N_FK N_CHECK N_TRIG N_ROUT N_SUPPLIED <<< "$METRICS"
echo "LIVE_DATABASE_METRICS=$N_TABLE/$N_COL/$N_FK/$N_CHECK/$N_TRIG/$N_ROUT supplied_lines=$N_SUPPLIED"
[[ "$N_TABLE" == 55 && "$N_COL" == 292 && "$N_FK" == 72 && "$N_CHECK" == 51 && "$N_TRIG" == 30 && "$N_ROUT" == 3 && "$N_SUPPLIED" == 132 ]] || die "Connected database is NOT the final validated version. Rebuild from the latest Cloudrest_Wines_Database.sql into a safe/local test instance and rerun."
python3 - "$PWD" "$TMP" <<'PY'
from pathlib import Path
import re,sys
root,tmp=map(Path,sys.argv[1:])
def clean(filename):
 s=(root/filename).read_text(encoding='utf-8')
 s='\n'.join(line for line in s.splitlines() if not re.match(r'^\s*(USE\s+cloudrestwines\s*;|--)',line,re.I))
 return s.strip()
for n,name in [(1,'trainingcoverage'),(2,'incidentrate'),(3,'trainingimpact'),(4,'overtimerisk')]:
 s=clean(f'database/queries/{n:02d}_{name}.sql')
 assert s.count(';')==1,(n,s.count(';'))
 (tmp/f'{n:02d}.sql').write_text(s+'\n')
q6=clean('database/queries/06_openactions.sql')
first,sep,second=q6.partition('\nEXPLAIN\n')
assert sep and first.count(';')==1 and second.count(';')==1
(tmp/'06.sql').write_text(first.strip()+'\n')
(tmp/'07.sql').write_text('EXPLAIN\n'+second.strip()+'\n')
(tmp/'05a.sql').write_text('CALL getExpiringQualifications(30);\n')
(tmp/'05b.sql').write_text('CALL getExpiringQualifications(90);\n')
(tmp/'00.sql').write_text("SELECT DATABASE() AS current_schema, VERSION() AS mysql_version, (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema='cloudrestwines') AS column_count;\n")
(tmp/'08.sql').write_text("""SELECT 'Imported customers' AS metric,COUNT(*) AS records FROM customer WHERE customerId LIKE 'VCUS%'
UNION ALL SELECT 'Imported addresses',COUNT(*) FROM address WHERE addressId LIKE 'VADR%'
UNION ALL SELECT 'Imported orders',COUNT(*) FROM customerorder WHERE customerOrderId LIKE 'VORD%'
UNION ALL SELECT 'Imported order lines',COUNT(*) FROM orderline WHERE customerOrderId LIKE 'VORD%';\n""")
PY
wb_activate(){ osascript -e 'tell application id "com.oracle.workbench.mysqlworkbench" to activate'; sleep 1; }
wb_exec(){
 local sql="$1"
 pbcopy < "$sql"
 wb_activate
 osascript <<'APPLE'
tell application "System Events"
 keystroke "t" using {command down}
 delay 1
 keystroke "v" using {command down}
 delay 1
 key code 36 using {command down}
end tell
APPLE
}
echo "Open MySQL Workbench now, connect to the SAME local MySQL server, and select the cloudrestwines default schema."
echo "Do not leave Workbench on the Connecting screen or only in the model editor."
echo "Place Workbench on the current macOS desktop and hide chat/apps/notifications before recording."
echo "Checking GUI with current database version and column count..."
wb_exec "$TMP/00.sql"
sleep 3
printf 'Does Workbench Result Grid display current_schema=cloudrestwines and column_count=292? Type YES to record: '
read -r confirm
[[ "$confirm" == YES ]] || die "GUI preflight not confirmed. No video recorded."
DEVICES="$(ffmpeg -hide_banner -f avfoundation -list_devices true -i '' 2>&1 || true)"
DEVICE="$(printf '%s\n' "$DEVICES" | sed -nE 's/.*\[([0-9]+)\][[:space:]]+Capture [Ss]creen 0.*/\1/p' | head -n1)"
[[ -n "${SCREEN_DEVICE:-}" ]] && DEVICE="$SCREEN_DEVICE"
[[ -n "$DEVICE" ]] || { echo "$DEVICES"; die "Screen 0 device missing. Set SCREEN_DEVICE to its avfoundation number."; }
mkdir -p "$PWD/deliverables/video" "$HOME/Downloads"
OUT="$PWD/deliverables/video/Cloudrest_Wines_Workbench_Demo_Final.mp4"
wb_activate
ffmpeg -nostdin -hide_banner -loglevel warning -f avfoundation -framerate 30 -thread_queue_size 512 -i "${DEVICE}:none" -t 285 \
 -vf 'scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,format=yuv420p' \
 -c:v libx264 -preset veryfast -crf 20 -pix_fmt yuv420p -movflags +faststart -an -y "$OUT" > "$TMP/ffmpeg.log" 2>&1 &
REC_PID="$!"
sleep 5
kill -0 "$REC_PID" 2>/dev/null || { cat "$TMP/ffmpeg.log"; die "Screen recording did not start. Check Terminal Screen Recording permission."; }
echo "Recording actual MySQL Workbench queries. Do not use the keyboard or switch desktops."
sleep 8
for entry in 01:22 02:22 03:20 04:24 05a:28 05b:28 06:27 07:27 08:25; do
 item="${entry%%:*}"; sec="${entry##*:}"
 echo "Executing $item from Git HEAD $HEAD"
 wb_exec "$TMP/$item.sql"
 sleep "$sec"
done
sleep 6
kill -INT "$REC_PID" 2>/dev/null || true
wait "$REC_PID" 2>/dev/null || true
REC_PID=""
[[ -s "$OUT" ]] || { cat "$TMP/ffmpeg.log"; die "MP4 missing or empty."; }
SIZE="$(stat -f %z "$OUT")"
[[ "$SIZE" -gt 1000000 ]] || die "MP4 suspiciously small; verify Screen Recording permission."
ffprobe -v error -show_entries format=duration,size:stream=codec_name,width,height -of default=noprint_wrappers=1 "$OUT"
cp -f "$OUT" "$HOME/Downloads/Cloudrest_Wines_Workbench_Demo_Final.mp4"
echo "RECORDING_GIT_HEAD=$HEAD"
echo "VIDEO_FILE=$HOME/Downloads/Cloudrest_Wines_Workbench_Demo_Final.mp4"
echo "IMPORTANT: Inspect the actual MP4. This does not automatically prove every Result Grid was captured. Updated ER screenshots are the students' separate responsibility."
