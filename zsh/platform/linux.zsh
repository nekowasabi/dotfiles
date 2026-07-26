# Linux/WSL specific settings

### brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# GNU ls カラー設定
alias ls="ls -GF"
alias gls="gls --color"

zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

# PATH設定（Linux固有）
export PATH=$PATH:/usr/local/bin:/bin:/usr/bin:$GOROOT/bin:$GOPATH/bin:/home/takets/bin:/home/takets/.bin:/home/takets/.deno/bin:/home/takets/.cargo/bin

# Deno設定
export DENO_INSTALL="/home/linuxbrew/.linuxbrew"
# Why: mise 管理の npm 版より単体版 Codex を優先し、更新時に読み取り専用 ~/.zshrc への追記を回避する。
export PATH="$HOME/.local/bin:$DENO_INSTALL/bin:$PATH"
