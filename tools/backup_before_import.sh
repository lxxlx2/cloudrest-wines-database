#!/usr/bin/env bash
set -euo pipefail
SCHEMA="${1:-cloudrestwines}"
OUT_DIR="${2:-$HOME/Cloudrest-Wines-Backups}"
mkdir -p "$OUT_DIR"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="$OUT_DIR/${SCHEMA}-before-import-${STAMP}.sql"
DUMP="${MYSQLDUMP:-mysqldump}"
HOST="${MYSQL_HOST:-127.0.0.1}"
PORT="${MYSQL_PORT:-3306}"
USER="${MYSQL_USER:-root}"
"$DUMP" --host="$HOST" --port="$PORT" --user="$USER" \
  --single-transaction --routines --triggers --set-gtid-purged=OFF \
  "$SCHEMA" > "$OUT"
if [[ ! -s "$OUT" ]]; then
  rm -f "$OUT"
  echo "BACKUP FAILED: no dump bytes" >&2
  exit 1
fi
echo "BACKUP_FILE=$OUT"
echo "BACKUP_BYTES=$(wc -c < "$OUT" | tr -d ' ')"
