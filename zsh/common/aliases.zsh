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
  elif [ -d "/Users/takets" ]; then
    /etc/profiles/per-user/takets/bin/nvim $1 $2
  else
    /opt/homebrew/bin/nvim  $1 $2 ~/work
  fi
}
alias n='wezterm_neovim'

# ============================================
# Claude CLI
# ============================================

# Claude with default permissions and model
alias c="MAX_THINKING_TOKENS=63999 claude --permission-mode auto "

cz() {
  ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic" ANTHROPIC_AUTH_TOKEN="${Z_API_KEY}" ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-5-turbo" ANTHROPIC_DEFAULT_SONNET_MODEL="glm-5.1" ANTHROPIC_DEFAULT_OPUS_MODEL="glm-5.1" claude --dangerously-skip-permissions "$@"
}

co() {
  ANTHROPIC_BASE_URL="https://ollama.com" ANTHROPIC_AUTH_TOKEN="${OLLAMA_AUTH_TOKEN}" ANTHROPIC_DEFAULT_HAIKU_MODEL="deepseek-v4-flash:cloud" ANTHROPIC_DEFAULT_SONNET_MODEL="deepseek-v4-flash:cloud" ANTHROPIC_DEFAULT_OPUS_MODEL="deepseek-v4-pro:cloud" claude --dangerously-skip-permissions
}
