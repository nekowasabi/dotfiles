# FZF Configuration
# =================

# FZF_DEFAULT_COMMAND: ripgrepを使用した高速なファイル検索
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'

# FZF_DEFAULT_OPTS: プレビュー、色設定、表示高さなど
export FZF_DEFAULT_OPTS='--height 80% --reverse --color=fg:white,fg+:bright-white,bg+:236,hl:yellow,hl+:bright-yellow,prompt:cyan,pointer:cyan,info:gray'


# ============================================================================
# select-history: Ctrl+Rでコマンド履歴をfzfで検索
# ============================================================================
source "${0:A:h}/select-history.zsh"


# ============================================================================
# fzf_find_path: Ctrl+Tでカレント以下のファイル・ディレクトリを検索
# ============================================================================
fzf_find_path() {
    # 現在のコマンドラインの状態を保存
    local original_lbuffer=$LBUFFER

    if [[ $LBUFFER == cd\ * ]]; then
        # 'cd'コマンドの場合はディレクトリのみを検索
        local path_prefix=${LBUFFER#cd }
        # 特殊文字を含むパスを正しく展開
        local expanded_path_prefix=$(eval echo $path_prefix)
        local selected_path=$(find "$expanded_path_prefix"* -type d 2> /dev/null | fzf)
    else
        local current_buffer=$LBUFFER
        local command_prefix=${current_buffer%% *}
        local path_prefix=${current_buffer#$command_prefix }
        local expanded_path_prefix=$(eval echo $path_prefix)
        local selected_path=$(find "$expanded_path_prefix"* -type f -o -type d 2> /dev/null | fzf)
    fi

    if [[ -n $selected_path ]]; then
        if [[ $LBUFFER == cd\ * ]]; then
            local trimmed_selected_path=${selected_path#$expanded_path_prefix}
            LBUFFER+="$trimmed_selected_path"
        else
            LBUFFER="$command_prefix $selected_path"
        fi
    else
        # fzfがキャンセルされた場合、元の状態を復元
        LBUFFER=$original_lbuffer
    fi
}

# Ctrl+t のキーバインドを設定
zle -N fzf_find_path
bindkey '^t' fzf_find_path


# ============================================================================
# fzf_migemo_find: Ctrl+Yでローマ字入力から日本語ファイル名を検索
# https://github.com/takets/zsh-migemo-completion
#
# fzf の内蔵 fuzzy matching を --disabled で切り、クエリが変わるたびに
# `rg --files | migemo-complete filter {q}` を再実行して候補を丸ごと入れ替える。
#
# Why: fzf に一覧を食わせて内蔵マッチャに任せる案ではなく reload 方式を採った。
# migemo 展開は「ローマ字クエリ → 日本語にもマッチする正規表現」への変換であり、
# fzf 側では表現できないため、絞り込み自体を外部プロセスに委ねる必要がある。
#
# バイナリ解決は migemo.zsh と同一ロジック。読み込み順序上 fzf.zsh のほうが
# 先に読まれるため、ここでも独立に解決する（両方 `: ${VAR:=...}` なので冪等）。
# ============================================================================
: ${MIGEMO_COMPLETE_BIN:=$HOME/repos/zsh-migemo-completion/migemo-complete}
if [[ ! -x $MIGEMO_COMPLETE_BIN ]]; then
    MIGEMO_COMPLETE_BIN=$(command -v migemo-complete 2>/dev/null)
fi

if [[ -n $MIGEMO_COMPLETE_BIN && -x $MIGEMO_COMPLETE_BIN ]]; then

    fzf_migemo_find() {
        # カーソル直前のトークンを初期クエリにし、確定時はそれを置換する
        local query=${LBUFFER##* }

        # Why: `--bind change:reload` に sleep を挟むデバウンスを入れた。
        # filter 1 回あたり実測 ~95ms（大半が migemo 辞書ロードの固定費）で、
        # 素の連打では毎打鍵ぶんプロセスが起動して取りこぼしが増えるため。
        local list_cmd="${FZF_DEFAULT_COMMAND:-find . -mindepth 1}"
        local reload_cmd="$list_cmd | ${(q)MIGEMO_COMPLETE_BIN} filter {q} 2>/dev/null"

        local selected
        selected=$(
            fzf --disabled \
                --query "$query" \
                --prompt 'migemo> ' \
                --bind "start:reload:$reload_cmd" \
                --bind "change:reload:sleep 0.05; $reload_cmd" \
                --no-multi < /dev/null
        )

        if [[ -n $selected ]]; then
            LBUFFER="${LBUFFER%"$query"}${(q-)selected}"
        fi
        zle reset-prompt
    }

    # Ctrl+y のキーバインドを設定（標準の yank を明示的に上書き）
    zle -N fzf_migemo_find
    bindkey '^y' fzf_migemo_find
fi


# ============================================================================
# ghq-fzf: Ctrl+gでghqリポジトリを選択してジャンプ
# ============================================================================
# ghq + fzf: リポジトリ選択してジャンプ
function ghq-fzf() {
  local selected_dir=$(ghq list -p | fzf --preview "ls -la {}" --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N ghq-fzf
bindkey '^g' ghq-fzf
