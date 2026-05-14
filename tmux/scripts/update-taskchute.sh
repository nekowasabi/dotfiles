#!/usr/bin/env bash
# Why: launchd で常駐管理することで、スリープ復帰や予期せぬ終了時にOSが自動再起動できるようにする
set -u

CACHE_DIR="$HOME/.cache/tmux"
CACHE_FILE="$CACHE_DIR/taskchute.txt"
TMP_FILE="$CACHE_FILE.tmp"
CLI="$HOME/repos/dashboard/backend/dist/cli/index.js"
INTERVAL=60
LAUNCHD_LABEL="com.user.taskchute"
LAUNCHD_PLIST="$HOME/Library/LaunchAgents/${LAUNCHD_LABEL}.plist"

mkdir -p "$CACHE_DIR"

# Why: --start は tmux 起動時の互換エントリ。launchd job が無ければ bootstrap、あればOSの管理に任せて即終了
if [ "${1:-}" = "--start" ]; then
  if [ -f "$LAUNCHD_PLIST" ]; then
    if ! launchctl print "gui/$UID/${LAUNCHD_LABEL}" >/dev/null 2>&1; then
      launchctl bootstrap "gui/$UID" "$LAUNCHD_PLIST" >/dev/null 2>&1 || true
    fi
  fi
  exit 0
fi

# Why: launchd から呼ばれる前景実行モード。PIDファイル管理は launchd に委譲したため不要
# Why: tmux サーバ未起動時は exit → launchd が ThrottleInterval=10s で再試行
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
      overtime) out='#[fg=default,bg=colour226]overtime#[default]' ;;
      *) out='' ;;
    esac
  fi

  printf '%s' "$out" > "$TMP_FILE"
  mv "$TMP_FILE" "$CACHE_FILE"
  sleep "$INTERVAL"
done
