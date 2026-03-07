#!/usr/bin/env zsh
# ============================================================================
# 共通関数ライブラリ
# WSL (wsl_zshrc) と macOS (mac_zshrc) で共有する関数を定義
# ============================================================================

# ============================================================================
# WezTerm 内で Neovim を起動する関数
# ============================================================================
# 説明: 環境に応じて適切な Neovim バイナリを実行
# 機能:
#   - /home/ttakeda が存在する場合 (macOS M1): /opt/homebrew/bin/nvim を使用
#   - /home/takets が存在する場合 (macOS Intel): ~/.local/nvim/bin/nvim を使用
#   - その他の環境: /usr/local/bin/nvim を使用
# 引数: $1 (オプション), $2 (オプション) - Neovim への引数
function wezterm_neovim() {
  if [ -d "/home/ttakeda" ]; then
    # macOS M1 の Homebrew インストール版
    /opt/homebrew/bin/nvim "$1" "$2" ~/work
  elif [ -d "/Users/takets" ]; then
    # macOS Intel の ローカルインストール版
    ~/.local/nvim/bin/nvim "$1" "$2"
  elif [ -d "/home/takets" ]; then
    # WSL / Linux 環境
    /home/takets/.nix-profile/bin/nvim "$1" "$2"
  else
    # フォールバック
    /usr/local/bin/nvim "$1" "$2"
  fi
}

# ============================================================================
# ディレクトリ移動履歴管理関数（powered_cd_*）
# ============================================================================
# 説明: 訪問したディレクトリ履歴を ~/.powered_cd.log に保存
# 機能:
#   - 最大99個のディレクトリを記録
#   - 重複するディレクトリは新しい訪問に更新
#   - chpwd フックで自動的に呼び出され、ディレクトリ移動を記録

# powered_cd_add_log: ディレクトリ移動ログに現在のディレクトリを追加
# 説明: chpwd フックから呼び出され、訪問したディレクトリを ~/.powered_cd.log に記録
# 処理:
#   1. ログファイルを配列として読み込む
#   2. 現在のディレクトリと重複する要素を除外
#   3. 現在のディレクトリを末尾に追加
#   4. 最大99件に丸めて一度だけ書き戻す
function powered_cd_add_log() {
  local log_file=~/.powered_cd.log
  local line
  local -a entries filtered_entries

  [[ -e "$log_file" ]] || : >| "$log_file"
  entries=("${(@f)$(<"$log_file")}")

  for line in "${entries[@]}"; do
    [[ -n "$line" && "$line" != "$PWD" ]] && filtered_entries+=("$line")
  done

  filtered_entries+=("$PWD")

  if (( ${#filtered_entries[@]} > 99 )); then
    filtered_entries=("${(@)filtered_entries[-99,-1]}")
  fi

  print -l -- "${filtered_entries[@]}" >| "$log_file"
}

# powered_cd_2: ディレクトリ履歴から fzf で選択して移動
# 説明: ~/.powered_cd.log から逆順（新しい順）に表示して fzf で選択
# 引数: なし（引数が指定されるとエラーメッセージを表示）
# 使用例: powered_cd_2
function powered_cd_2() {
  if [ $# = 0 ]; then
    # ログを逆順にして fzf で選択、選択結果のディレクトリへ移動
    cd "$(tail -r ~/.powered_cd.log | fzf)"
  else
    echo "powered_cd_2: This command does not accept any arguments."
  fi
}

# ============================================================================
# chpwd フック: ディレクトリ変更時に自動実行
# ============================================================================
# 説明: zsh の chpwd フックに powered_cd_add_log を登録
autoload -Uz add-zsh-hook
(( ${chpwd_functions[(I)powered_cd_add_log]} )) || add-zsh-hook chpwd powered_cd_add_log

# ============================================================================
# powered_cd_2 を Ctrl+Z で実行するショートカット
# ============================================================================
# 説明: powered_cd_2 を zle ウィジェットでラップし、キーバインド設定可能にする
function run_powered_cd_2() {
  echo "run_powered_cd_2"
  clear
  powered_cd_2
  zle reset-prompt
  zle redisplay
}
zle -N run_powered_cd_2
bindkey '^z' run_powered_cd_2

# ============================================================================
# powered_cd の補完設定
# ============================================================================
_powered_cd() {
  _files -/
}
compdef _powered_cd powered_cd

# powered_cd.log ファイルが存在しなければ作成
[ -e ~/.powered_cd.log ] || touch ~/.powered_cd.log

# ============================================================================
# ghq + fzf + fd/rg 連携関数
# ============================================================================

# ghqリポジトリを選択し、その中のファイルをfdで検索してエディタで開く
function ghq_fd() {
  local repo=$(ghq list | fzf --preview "eza --tree --level=2 --color=always $(ghq root)/{}")
  [[ -z "$repo" ]] && return

  local repo_path="$(ghq root)/$repo"
  local file=$(fd --type f . "$repo_path" | fzf --preview "bat --color=always {}")
  [[ -z "$file" ]] && return

  nvim "$file"
}

# ghqリポジトリを選択し、その中をrgで検索してファイルを開く
function ghq_rg() {
  local repo=$(ghq list | fzf --preview "eza --tree --level=2 --color=always $(ghq root)/{}")
  [[ -z "$repo" ]] && return

  local repo_path="$(ghq root)/$repo"

  # rg + fzf でインタラクティブ検索（入力するたびに検索実行）
  local selection=$(: | fzf --ansi --disabled \
    --bind "change:reload:rg --color=always --line-number --no-heading --smart-case {q} \"$repo_path\" 2>/dev/null || true" \
    --preview 'bat --color=always --highlight-line {2} {1}' \
    --preview-window '+{2}-10' \
    --delimiter ':' \
    --header '検索ワードを入力')

  [[ -z "$selection" ]] && return

  local file=$(echo "$selection" | cut -d':' -f1)
  local line=$(echo "$selection" | cut -d':' -f2)
  nvim "+$line" "$file"
}

# エイリアス
alias gf='ghq_fd'
alias gr='ghq_rg'
