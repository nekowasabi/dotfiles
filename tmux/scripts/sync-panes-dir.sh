#!/usr/bin/env bash
# Why: tmuxには「同一ウィンドウの全ペインへcdを一括伝播する」ネイティブコマンドが無いため、
#      各ペインのシェルへ send-keys で cd コマンド文字列を打鍵として流し込んで実現する。
set -u

target_path="${1:?target_path required}"
window_id="${2:?window_id required}"
active_pane="${3:?active_pane required}"

tmux list-panes -t "$window_id" -F '#{pane_id}' | while IFS= read -r pane_id; do
  if [ "$pane_id" = "$active_pane" ]; then
    # フォーカス中のペイン自身は既に target_path 上のため cd は不要だが、
    # 見た目の一貫性のため画面クリアだけは行う
    tmux send-keys -t "$pane_id" C-l
    continue
  fi
  # 先頭スペース: HIST_IGNORE_SPACE(zsh)/HISTCONTROL=ignorespace(bash) 環境で
  #               この自動cdをシェル履歴に残さないため
  tmux send-keys -t "$pane_id" " cd -- $(printf '%q' "$target_path")" Enter
  # cd実行後に画面をクリアし、cdコマンド行や直前の出力を消す
  tmux send-keys -t "$pane_id" C-l
done
