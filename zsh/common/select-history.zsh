# ============================================================================
# select-history: Ctrl+R でコマンド履歴をfzfで検索（フィルタリング対応）
#
# 除外キーワードを追加するには任意のzshrcに追記:
#   HISTORY_FILTER_KEYWORDS+=('除外したいパターン')
# ============================================================================
typeset -ga HISTORY_FILTER_KEYWORDS
HISTORY_FILTER_KEYWORDS=(
    'CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS'
)

function select-history() {
    local hist
    hist=$(history -n -r 1)
    if (( ${#HISTORY_FILTER_KEYWORDS[@]} > 0 )); then
        local pattern="${(j:|:)HISTORY_FILTER_KEYWORDS}"
        hist=$(echo "$hist" | grep -vE "$pattern")
    fi
    BUFFER=$(echo "$hist" | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
    CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^r' select-history
