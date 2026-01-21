#!/bin/zsh
# Entry point for WSL environment
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
# Platform-specific settings (Linux/WSL)
# ============================================================
source "$DOTFILES_ZSH/platform/linux.zsh"

# ============================================================
# Environment-specific settings (WSL)
# ============================================================
source "$DOTFILES_ZSH/env/wsl.zsh"
