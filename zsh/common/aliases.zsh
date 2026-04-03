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
alias c="MAX_THINKING_TOKENS=63999 claude --dangerously-skip-permissions --model opus "

# Claude with Sonnet model
alias cs="claude --dangerously-skip-permissions --model sonnet"

# Claude with Opus model
alias co="claude --dangerously-skip-permissions --model opus"

# Quatarly (token stored in ~/.zshenv as $QUATARLY_AUTH_TOKEN)
# Why: inline VAR=value command ではなく export 方式 — Claude Code がインライン環境変数を読み取れず 502 エラーになるため
cq() {
  ANTHROPIC_BASE_URL="https://api.quatarly.cloud/" ANTHROPIC_AUTH_TOKEN="${QUATARLY_API_KEY}" ANTHROPIC_DEFAULT_HAIKU_MODEL="claude-haiku-4-5-20251001" ANTHROPIC_DEFAULT_SONNET_MODEL="claude-sonnet-4-6-20250929" ANTHROPIC_DEFAULT_OPUS_MODEL="claude-opus-4-6-thinking" claude --dangerously-skip-permissions "$@"
}
cz() {
  ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic" ANTHROPIC_AUTH_TOKEN="${Z_API_KEY}" ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-5-turbo" ANTHROPIC_DEFAULT_SONNET_MODEL="glm-5.1" ANTHROPIC_DEFAULT_OPUS_MODEL="glm-5.1" claude --dangerously-skip-permissions "$@"
}

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
# Home Manager 側で先に初期化済みなら再実行しない。
if ! whence -w __zoxide_z >/dev/null 2>&1; then
  eval "$(zoxide init zsh --no-cmd)"
fi

# j: zoxide wrapper - 引数なしならfzf、引数ありなら最初の候補に即ジャンプ
j() {
  local result

  if (( $# == 0 )); then
    result="$(command zoxide query --interactive -- "$@")" && builtin cd -- "$result"
    return
  fi

  if [[ $# -eq 1 ]] && { [[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]$ ]]; }; then
    builtin cd -- "$1"
    return
  fi

  if [[ $# -eq 2 && "$1" = "--" ]]; then
    builtin cd -- "$2"
    return
  fi

  result="$(command zoxide query --exclude "$PWD" -- "$@")" && builtin cd -- "$result"
}

# ji: zoxide interactive - fzf で絞り込みジャンプ（引数あり/なし両対応）
ji() {
  local result
  result="$(command zoxide query --interactive -- "$@")" && builtin cd -- "$result"
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
