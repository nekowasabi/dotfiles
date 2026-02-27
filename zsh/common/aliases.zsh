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
alias c="MAX_THINKING_TOKENS=63999 claude --dangerously-skip-permissions "

# Claude with Sonnet model
alias ys="claude --dangerously-skip-permissions --model sonnet"

# Claude with Opus model
alias yo="claude --dangerously-skip-permissions --model opus"

# ============================================
# Development Tools
# ============================================

# ============================================
# Repository Management (ghq)
# ============================================

# ghq + fzf: リポジトリ選択してジャンプ
alias g='dir=$(ghq list -p | fzf --preview "ls -la {}"); [ -n "$dir" ] && cd "$dir"'

# git-wt: worktree選択してジャンプ
alias w='dir=$(git-wt | fzf | awk '\''{print $1}'\''); [ -n "$dir" ] && cd "$dir"'

# git-wt: 現在のブランチのworktreeを削除
alias wd='git wt -d $(git branch --show-current)'

# ============================================
# GitHub
# ============================================

# GitHub PR list page in browser
alias gpl='gh pr list --web'

# ============================================
# zoxide (directory jumper)
# ============================================

# zoxide初期化（--no-cmd: z/zi の自動定義を抑制し、カスタム関数で上書き）
eval "$(zoxide init zsh --no-cmd)"

# j: zoxide wrapper - 候補1件なら即ジャンプ、複数件ならfzfで選択
j() {
  if [ $# -eq 0 ]; then
    __zoxide_zi
    return
  fi

  local n
  n="$(zoxide query -l -- "$@" 2>/dev/null | wc -l | tr -d ' ')"

  if [ "${n:-0}" -ge 2 ]; then
    __zoxide_zi "$@"
  else
    __zoxide_z "$@"
  fi
}

# ============================================
# tmux
# ============================================

# zsh-reload-all: tmux全ペインのアイドル状態のzshに source ~/.zshrc を送信
zsh-reload-all() {
  tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}' \
    | grep -E ' (zsh|bash)$' \
    | awk '{print $1}' \
    | xargs -I {} tmux send-keys -t {} 'source ~/.zshrc' Enter
}
