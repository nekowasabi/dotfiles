# Work (ttakeda) environment specific settings

# setting path {{{1
export DENO_INSTALL="/Users/ttakeda/.deno"
export PATH=/usr/local/bin:/bin:/usr/bin:$DENO_INSTALL/bin:/Users/ttakeda/go/bin:/opt/homebrew/bin:$HOME/.nodenv/bin:/opt/homebrew/opt/php@8.1/bin:/opt/homebrew/opt/php@8.1/sbin:~/.deno/bin/:/opt/homebrew/Cellar/python@3.11/3.11.6_1/libexec/bin:$PATH:/Users/ttakeda/.luarocks:/Users/ttakeda/.luarocks/lib/luarocks/rocks-5.4:/Users/ttakeda/bin:~/.cargo/bin:/Users/ttakeda/.local/bin

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

export NVIM_NODE_LOG_FILE='/Users/ttakeda/nvim_node_log.log'
export NVIM_NODE_LOG_LEVEL=info
export FZF_PREVIEW_DEBUG=1
export DENOPS_TEST_DENOPS_PATH=/Users/ttakeda/.config/nvim/plugged/denops.vim
export DENOPS_TEST_VIM=/usr/local/bin/vim
export DENOPS_PATH=/Users/ttakeda/.config/nvim/plugged/denops.vim
export DENOPS_TEST_NVIM=/usr/local/bin/nvim
export MOCWORD_DATA='/Users/ttakeda/.config/mocword/mocword.sqlite'
export ZENO_HOME='/Users/ttakeda/.config/zeno'
export RIPGREP_CONFIG_PATH='/Users/ttakeda/.ripgreprc'
# }}}1

# php@8.3 path
export PATH="/opt/homebrew/opt/php@8.3/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.3/sbin:$PATH"

# Windsurf
export PATH="/Users/ttakeda/.codeium/windsurf/bin:$PATH"

# Google Cloud SDK
if [ -f '/Users/ttakeda/google-cloud-sdk/path.zsh.inc' ]; then
  . '/Users/ttakeda/google-cloud-sdk/path.zsh.inc'
fi

if [ -f '/Users/ttakeda/google-cloud-sdk/completion.zsh.inc' ]; then
  . '/Users/ttakeda/google-cloud-sdk/completion.zsh.inc'
fi

# Antigravity
export PATH="/Users/ttakeda/.antigravity/antigravity/bin:$PATH"

# tmux session switching
alias tw='tmux switch-client -t invase-web'   # web環境へ切り替え
alias ta='tmux switch-client -t invase-app'   # app環境へ切り替え
alias tl='tmux switch-client -l'              # 直前の環境へトグル
alias ts='tmux list-sessions'                 # セッション一覧表示

# neovim functions and aliases
function wezterm_neovim_work() {
 /opt/homebrew/bin/nvim  $1 $2 ~/work
}
alias m='wezterm_neovim_work'

# Claude CLI with extended thinking
alias c="MAX_THINKING_TOKENS=63999 claude --dangerously-skip-permissions"
alias cg="MAX_THINKING_TOKENS=63999 claude --dangerously-skip-permissions --chrome"
