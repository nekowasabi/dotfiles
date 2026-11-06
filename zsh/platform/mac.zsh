# macOS specific settings

# GNU date alias
alias date="gdate"

# ctags設定
# Why: `brew --prefix` は毎回サブプロセス起動(24ms)。Apple Silicon Mac は /opt/homebrew 固定。
alias ctags="/opt/homebrew/bin/ctags"

# Homebrew path設定
export PATH=$PATH:/usr/local/bin:/bin:/usr/bin

# Mac固有のPATH追加
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:/Users/takets/.nodebrew/current/bin:/Users/takets/go/bin:/Users/takets/.cargo/bin:/usr/local/Cellar/python@3.13/3.13.0_1/bin::$DENO_INSTALL/bin:/Users/takets/.deno/bin:/Users/takets/.local/bin:/Users/takets/bin:/Users/takets/tmp/nvim-macos-x86_64/bin

# Mac固有の環境変数

# Why: Starting zsh inherits the old option; it prevents Claude Code from loading its bundled CAs.
if [[ $NODE_OPTIONS == *--use-openssl-ca* ]]; then
  export NODE_OPTIONS="${NODE_OPTIONS//--use-openssl-ca/}"
fi

# eMudhra 中間 CA 漏えい(2026-10-20)の暫定対策: Deno の同梱 CA ストアを更新済みの brew バンドルに差し替える
# Why: Instead of --use-system-ca / DENO_TLS_CA_STORE=system, adopted the brew bundle — keychain 経由では Apple の中間 CA ブロックが効かず漏えい CA を信頼したままだった
# ponytail: Node・Deno の修正版が出たらこのブロックを削除する
_brew_ca=/opt/homebrew/etc/ca-certificates/cert.pem
if [[ -r $_brew_ca ]]; then
  export SSL_CERT_FILE=${SSL_CERT_FILE:-$_brew_ca}
  export DENO_TLS_CA_STORE= DENO_CERT=$SSL_CERT_FILE
fi
unset _brew_ca

# zsh補完パス（Mac固有）
fpath=(/usr/local/share/zsh-completions ${fpath})

# Mac固有のls設定
alias ls="ls -GF"
alias gls="gls --color"

# ByteRover CLI
# Why: work は lib/bin を使う。ここでも bin/ を足すと後勝ちで上書きされる。
if [[ "$PC" != "work" ]]; then
  export PATH="$HOME/.brv-cli/bin:$PATH"
fi

source "${DOTFILES_ZSH:-$HOME/repos/dotfiles/zsh}/platform/mac-zprofile.zsh"

# keypipe: the daemon ignores terminals, so this widget runs the JSON rules at the zsh prompt
# Why: an installed keypipe on PATH wins so a release install is not shadowed by a stale debug build
if [[ -r $HOME/repos/keypipe/shell/keypipe.zsh ]]; then
  export KEYPIPE_BIN=${commands[keypipe]:-$HOME/repos/keypipe/.build/debug/keypipe}
  export KEYPIPE_CONFIG=${XDG_CONFIG_HOME:-$HOME/.config}/keypipe/config.json
  source $HOME/repos/keypipe/shell/keypipe.zsh
fi

# Rex: the app puts its CLI dir at the front of PATH, but the PATH edits above push it back; restore it last
# Why: private.zsh, sourced after this file, only appends to PATH, so the front position survives
if [[ -n $REX_BIN_DIR ]]; then
  export PATH="$REX_BIN_DIR:$PATH"
fi
