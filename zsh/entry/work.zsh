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

# pnpm
export PNPM_HOME="/Users/ttakeda/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Why: PATH が253エントリに肥大化（42重複）。typeset -U は配列の重複要素を自動除去。
# path（小文字）は PATH（大文字）と連動する zsh 特殊変数。
typeset -U path fpath
