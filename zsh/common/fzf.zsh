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
