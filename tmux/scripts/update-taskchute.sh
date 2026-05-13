#!/usr/bin/env bash
# Why: keep tmux status rendering fast by caching the TaskChute state outside #().
set -u

CACHE_DIR="$HOME/.cache/tmux"
CACHE_FILE="$CACHE_DIR/taskchute.txt"
TMP_FILE="$CACHE_FILE.tmp"
PID_FILE="$CACHE_DIR/taskchute.pid"
CLI="$HOME/repos/dashboard/backend/dist/cli/index.js"
INTERVAL=60

mkdir -p "$CACHE_DIR"

if [ "${1:-}" = "--start" ]; then
  pid="$(cat "$PID_FILE" 2>/dev/null || true)"
  if [ -n "$pid" ] &&
    kill -0 "$pid" 2>/dev/null &&
    ps -p "$pid" -o command= 2>/dev/null | grep -F "update-taskchute.sh" >/dev/null; then
    exit 0
  fi

  nohup "$0" >/dev/null 2>&1 &
  exit 0
fi

printf '%s\n' "$$" > "$PID_FILE"
cleanup() {
  rm -f "$PID_FILE" "$TMP_FILE"
}
trap cleanup EXIT
trap 'cleanup; exit 0' INT TERM

while true; do
  if ! tmux has-session 2>/dev/null; then
    exit 0
  fi

  out=""
  if json="$(node "$CLI" output taskchute 2>/dev/null)"; then
    state="$(printf '%s' "$json" | jq -r '.state // empty' 2>/dev/null)"
    case "$state" in
      running) out='#[fg=default,bg=colour28]doing#[default]' ;;
      none) out='#[fg=default,bg=colour196]no task#[default]' ;;
      overtime) out='#[fg=colour232,bg=colour226]overtime#[default]' ;;
      *) out='' ;;
    esac
  fi

  printf '%s' "$out" > "$TMP_FILE"
  mv "$TMP_FILE" "$CACHE_FILE"
  sleep "$INTERVAL"
done
