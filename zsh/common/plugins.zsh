################################################################################
# Common Zsh Plugins Configuration
# This file contains common plugin configurations shared across zshrc variants
################################################################################

# ============================================================================
# Zinit Annexes - Required for plugin functionality
# ============================================================================
# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ============================================================================
# Auto-completion and Suggestion Plugins
# ============================================================================

# zsh-autosuggestions: Fish-like autosuggestions for zsh
# Suggests commands based on history as you type
zinit light zsh-users/zsh-autosuggestions

# zsh-completions: Additional completion definitions for zsh
# Enhances built-in completion with more definitions
zinit light zsh-users/zsh-completions

# ============================================================================
# Prompt Theme
# ============================================================================

# Pure: A minimal, beautiful, and fast zsh prompt
# pick: Loads async.zsh for async operations
# src: Loads pure.zsh as the main prompt theme
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

# ============================================================================
# Syntax Highlighting
# ============================================================================

# fast-syntax-highlighting: Faster alternative to zsh-syntax-highlighting
# Provides real-time syntax highlighting of commands
zinit light zdharma-continuum/fast-syntax-highlighting

# ============================================================================
# Command-line Tools
# ============================================================================

# fzf-bin: FZF (fuzzy finder) binary
# from"gh-r": Downloads from GitHub releases
# as"program": Treats as executable program
zinit ice from"gh-r" as"program"
zinit load junegunn/fzf-bin

# cd-bookmark: Bookmark and navigate directories quickly
# Allows marking directories for quick access
zinit light mollifier/cd-bookmark
autoload -Uz cd-bookmark
alias b='cd-bookmark'

# ============================================================================
# Plugin Configuration
# ============================================================================

# zsh-autosuggestions configuration
# Enable async suggestions for better performance
ZSH_AUTOSUGGEST_USE_ASYNC=1

# fast-syntax-highlighting theme configuration
function set_fast_theme() {
  FAST_HIGHLIGHT_STYLES[alias]='fg=blue'
  FAST_HIGHLIGHT_STYLES[suffix-alias]='fg=blue'
  FAST_HIGHLIGHT_STYLES[builtin]='fg=blue'
  FAST_HIGHLIGHT_STYLES[function]='fg=blue'
  FAST_HIGHLIGHT_STYLES[command]='fg=blue'
  FAST_HIGHLIGHT_STYLES[precommand]='fg=blue,underline'
  FAST_HIGHLIGHT_STYLES[hashed-command]='fg=blue'
  FAST_HIGHLIGHT_STYLES[path]='fg=green'
  FAST_HIGHLIGHT_STYLES[globbing]='fg=green,bold'
  FAST_HIGHLIGHT_STYLES[history-expansion]='fg=green,bold'
}
