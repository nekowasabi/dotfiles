# Private (takets) environment specific settings
# Guard: mkBefore で先行 source されるため二重読み込みを防止
[[ -n $_PRIVATE_ZSH_LOADED ]] && return
_PRIVATE_ZSH_LOADED=1

export PC="private"

# 復号キーの読み込み（dotenvx用）
[ -f "$HOME/.zshenv.local" ] && source "$HOME/.zshenv.local"

# dotenvx による機密情報の復号と読み込み
if command -v dotenvx &> /dev/null && [ -f "$HOME/.env.zsh" ]; then
  # シンボリックリンクを解決して実体パスを使用
  local env_file="$(readlink -f "$HOME/.env.zsh" 2>/dev/null || echo "$HOME/.env.zsh")"
  # shellフォーマットで取得してexport（子プロセスに継承されるようにする）
  eval "export $(dotenvx get --format shell -f "$env_file" 2>/dev/null || true)"
fi

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

# mise (runtime version manager)
# hook-env を毎回自動実行せず、プロジェクト境界をまたぐ時だけ更新する。
eval "$(/etc/profiles/per-user/takets/bin/mise activate zsh --no-hook-env)"

_mise_hook() {
  if (( $# > 0 )); then
    eval "$(/etc/profiles/per-user/takets/bin/mise hook-env -s zsh --reason "$1")"
  else
    eval "$(/etc/profiles/per-user/takets/bin/mise hook-env -s zsh)"
  fi
}

_mise_config_root_for_dir() {
  local dir=${1:-$PWD}
  dir=${dir:A}

  while true; do
    if [[ -f "$dir/.mise.toml" || -f "$dir/mise.toml" || -f "$dir/.tool-versions" || -f "$dir/mise.local.toml" ]]; then
      print -r -- "$dir"
      return 0
    fi

    [[ "$dir" == "/" ]] && return 1
    dir=${dir:h}
  done
}

_mise_maybe_hook_env() {
  local root=""
  root="$(_mise_config_root_for_dir "$PWD")" || root=""

  if [[ "${_MISE_LAST_ROOT-}" == "$root" ]]; then
    return 0
  fi

  _MISE_LAST_ROOT="$root"
  _mise_hook chpwd
}

autoload -Uz add-zsh-hook
(( ${chpwd_functions[(I)_mise_maybe_hook_env]} )) || add-zsh-hook chpwd _mise_maybe_hook_env
_mise_maybe_hook_env
