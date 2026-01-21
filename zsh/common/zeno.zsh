# zeno configuration
# https://github.com/yuki-yano/zeno.zsh

# zinit load
zinit ice lucid depth"1" blockf
zinit light yuki-yano/zeno.zsh

# ZENO_HOME設定
export ZENO_HOME=~/.config/zeno

# git folder preview with color
export ZENO_GIT_TREE="exa --tree"
export ZENO_GIT_CAT="bat --color=always"

# FZF TMUX options
export ZENO_FZF_TMUX_OPTIONS="-p"

# zeno key bindings
if [[ -n $ZENO_LOADED ]]; then
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
fi
