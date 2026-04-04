# zeno configuration
# https://github.com/yuki-yano/zeno.zsh

# ZENO_HOME設定
export ZENO_HOME=~/.config/zeno

# zinit load
zinit ice lucid depth"1" blockf
zinit light yuki-yano/zeno.zsh

# git folder preview with color
export ZENO_GIT_TREE="eza --tree"
export ZENO_GIT_CAT="bat --color=always"

# FZF TMUX options
export ZENO_FZF_TMUX_OPTIONS="-p"

# config.yml変更後にzenoを即時反映するリロード関数
function zeno-reload() {
  local zeno_plugin_dir="${ZINIT[PLUGINS_DIR]}/yuki-yano---zeno.zsh"
  if [[ -d "$zeno_plugin_dir" ]]; then
    pkill -f "deno.*zeno" 2>/dev/null
    sleep 0.3
    source "$zeno_plugin_dir/zeno.zsh"
    echo "✓ zeno.zsh reloaded"
  else
    echo "✗ zeno.zsh plugin directory not found"
  fi
}

# zeno key bindings
# Why: ZENO_LOADED ではなく ZENO_ENABLE — ZENO_LOADED は zeno-init (deno cache後) で遅延設定されるため、
# bootstrap 完了時点で同期的に設定される ZENO_ENABLE でチェックする
if [[ -n $ZENO_ENABLE ]]; then
  snippet_and_completion() {
    zeno-auto-snippet
    zeno-completion
  }
  zle -N snippet_and_completion
  bindkey '^x^x' snippet_and_completion

  bindkey '^u'  zeno-auto-snippet
  bindkey '^o' zeno-auto-snippet-and-accept-line
  bindkey '^i' zeno-completion
  bindkey '^x^s' zeno-insert-snippet
  export ZENO_COMPLETION_FALLBACK=expand-or-complete

  # ghq cd後にtmuxセッション名をリポジトリ名にリネーム
  function zeno-ghq-cd-post-hook-impl() {
    local dir="$ZENO_GHQ_CD_DIR"
    if [[ -n $TMUX ]]; then
      local repository=${dir:t}
      local session=${repository//./-}
      tmux rename-session "${session}"
    fi
  }
  zle -N zeno-ghq-cd-post-hook zeno-ghq-cd-post-hook-impl
fi
