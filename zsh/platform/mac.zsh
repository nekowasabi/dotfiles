# macOS specific settings

# GNU date alias
alias date="gdate"

# ctags設定
alias ctags="`brew --prefix`/bin/ctags"

# Homebrew path設定
export PATH=$PATH:/usr/local/bin:/bin:/usr/bin

# Mac固有のPATH追加
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:/Users/takets/.nodebrew/current/bin:/Users/takets/go/bin:/Users/takets/.cargo/bin:/usr/local/Cellar/python@3.13/3.13.0_1/bin::$DENO_INSTALL/bin:/Users/takets/.deno/bin:/Users/takets/.local/bin:/Users/takets/bin:/Users/takets/tmp/nvim-macos-x86_64/bin

# Mac固有の環境変数
export GOROOT=/usr/local/opt/go/libexec

# zsh補完パス（Mac固有）
fpath=(/usr/local/share/zsh-completions ${fpath})

# Mac固有のls設定
alias ls="ls -GF"
alias gls="gls --color"
