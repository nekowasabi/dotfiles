#!/bin/zsh
# Entry point for private Mac environment (takets)
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
# Environment-specific settings (private/takets)
# ============================================================
source "$DOTFILES_ZSH/env/private.zsh"
