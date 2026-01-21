# Common Aliases
# Shared aliases across all zsh configurations

# ============================================
# File Operations
# ============================================

alias ls="ls -GF"
alias gls="gls --color"

# eza: modern ls replacement
alias ll='eza --long --header --git --sort=type --classify --git'
alias la='eza --long --header --git --grid --classify --sort=type --git'

# Directory navigation shortcuts
alias ...='cd ../../'
alias ....='cd ../../../'

# cd-bookmark integration
alias b='cd-bookmark'

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
    /usr/local/bin/nvim $1 $2 ~/wezterm
  fi
}
alias n='wezterm_neovim'

# Nvim direct alias (Homebrew path)
alias v='/home/linuxbrew/.linuxbrew/bin/nvim'

# ============================================
# Claude CLI
# ============================================

# Claude with default permissions and model
alias c="claude --dangerously-skip-permissions"

# Claude with Sonnet model
alias ys="claude --dangerously-skip-permissions --model sonnet"

# Claude with Opus model
alias yo="claude --dangerously-skip-permissions --model opus"

# ============================================
# Development Tools
# ============================================

# PHP tags
alias phpctags='/usr/local/bin/phpctags'

# Python & Pip (Homebrew versions)
alias python3='/home/linuxbrew/.linuxbrew/bin/python3.12'
alias pip3='/home/linuxbrew/.linuxbrew/bin/pip3.12'
