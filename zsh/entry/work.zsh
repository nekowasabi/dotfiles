#!/bin/zsh
# Entry point for work Mac environment (ttakeda)
# ============================================================

DOTFILES_ZSH="$HOME/repos/dotfiles/zsh"

# ============================================================
# Common settings (shared across all environments)
# ============================================================
source "$DOTFILES_ZSH/common/zinit.zsh"
source "$DOTFILES_ZSH/common/standard.zsh"
source "$DOTFILES_ZSH/common/plugins.zsh"
source "$DOTFILES_ZSH/common/fzf.zsh"
source "$DOTFILES_ZSH/common/zeno.zsh"
source "$DOTFILES_ZSH/common/functions.zsh"
source "$DOTFILES_ZSH/common/aliases.zsh"

# ============================================================
# Platform-specific settings (macOS)
# ============================================================
source "$DOTFILES_ZSH/platform/mac.zsh"

# ============================================================
# Environment-specific settings (work/ttakeda)
# ============================================================
source "$DOTFILES_ZSH/env/work.zsh"

# sup - GitHub PR picker
sup() {
  rm -f /tmp/sup-selection
  command sup "$@"
  if [[ -f /tmp/sup-selection ]]; then
    cd "$(cat /tmp/sup-selection)"
    rm -f /tmp/sup-selection
  fi
}
