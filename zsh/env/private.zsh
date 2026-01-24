# Private (takets) environment specific settings

# takets専用のPATH設定
export PATH=$PATH:/usr/local/bin:/bin:/usr/bin:$GOROOT/bin:$GOPATH/bin:/Users/takets/.nodebrew/current/bin:/Users/takets/go/bin:/Users/takets/.cargo/bin::$DENO_INSTALL/bin:$PATH:/Users/takets/.deno/bin:/Users/takets/.local/bin:/Users/takets/bin:/Users/takets/tmp/nvim-macos-x86_64/bin:/Users/takets/tmp/nvim-macos-x86_64

# Python environment
export PYENV_ROOT=$HOME/.pyenv

# Deno environment
export DENO_INSTALL="/Users/takets/.deno/bin"

# Neovim debug logging (takets specific)
export NVIM_NODE_LOG_FILE='/Users/takets/nvim_node_log.log'
export NVIM_NODE_LOG_LEVEL=info

# Denops settings (takets specific)
export DENOPS_PATH=/Users/takets/.vim/plugged/denops.vim
export DENOPS_TEST_NVIM=/usr/local/bin/nvim
export DENOPS_TEST_DENOPS_PATH=/Users/takets/.config/nvim/plugged/denops.vim
export DENOPS_TEST_VERBOSE=1

# Mocword configuration (takets specific)
export MOCWORD_DATA='/Users/takets/.config/mocword/mocword.sqlite'

# Google Cloud SDK (takets specific)
if [ -f '/Users/takets/google-cloud-sdk/path.zsh.inc' ]; then
  . '/Users/takets/google-cloud-sdk/path.zsh.inc'
fi

if [ -f '/Users/takets/google-cloud-sdk/completion.zsh.inc' ]; then
  . '/Users/takets/google-cloud-sdk/completion.zsh.inc'
fi

# takets専用のエイリアス
# mise managed - aliases removed to use mise shims
# python, pip, pip3, deno are managed by mise (~/.local/share/mise/shims/)
