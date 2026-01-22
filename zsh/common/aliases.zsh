# Common Aliases
# Shared aliases across all zsh configurations

# ============================================
# File Operations
# ============================================

alias ls="ls -GF"
alias gls="gls --color"

# eza: modern ls replacement
alias ll='eza --long --header --git --sort=type --classify --git'
alias la='eza -la --long --header --git --grid --classify --sort=type --git'

# Directory navigation shortcuts
alias ...='cd ../../'
alias ....='cd ../../../'

# ============================================
# Editor & IDE
# ============================================

# Neovim with environment-aware path selection
# NOTE: Path can be customized by setting NVIM_PATH environment variable
# Default paths checked:
#   - /home/linuxbrew/.linuxbrew/bin/nvim (Homebrew on Linux)
#   - /home/takets/.nix-profile/bin/nvim (Nix profile)
#   - /usr/local/bin/nvim (System fallback)
function wezterm_neovim() {
  if [ -d "/home/ttakeda" ]; then
    /opt/homebrew/bin/nvim  $1 $2 ~/work
  elif [ -d "/home/takets" ]; then
    /home/takets/.nix-profile/bin/nvim $1 $2
  else
    /opt/homebrew/bin/nvim  $1 $2 ~/work
  fi
}
alias n='wezterm_neovim'

# ============================================
# Claude CLI
# ============================================

# Claude with default permissions and model
alias c="MAX_THINKING_TOKENS=63999 claude --dangerously-skip-permissions"

# Claude with Sonnet model
alias ys="claude --dangerously-skip-permissions --model sonnet"

# Claude with Opus model
alias yo="claude --dangerously-skip-permissions --model opus"

# ============================================
# Development Tools
# ============================================

# Python & Pip (Homebrew versions)
alias python3='/home/linuxbrew/.linuxbrew/bin/python3.12'
alias pip3='/home/linuxbrew/.linuxbrew/bin/pip3.12'

# ============================================
# Repository Management (ghq)
# ============================================

# ghq + fzf: リポジトリ選択してジャンプ
alias g='cd $(ghq list -p | fzf --preview "ls -la {}")'
