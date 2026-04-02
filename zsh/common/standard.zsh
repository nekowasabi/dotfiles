# Standard zsh settings

stty stop undef

# =========================
# Environment Variables
# =========================
export EDITOR=nvim
export VISUAL=nvim

# =========================
# Colors
# =========================
autoload -Uz colors
colors

# =========================
# Completion
# =========================
autoload -Uz compinit
# Why: compinit -u は毎回フルスキャン(302ms)。-C はキャッシュ(.zcompdump)利用で高速化。
# 24時間以上古い場合のみフルスキャンし、それ以外はキャッシュを使う。
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# =========================
# Emacs Key Bindings
# =========================
bindkey -e

# =========================
# History Settings
# =========================
# Share history with other terminals
setopt share_history

# Don't display duplicates in history
setopt histignorealldups

# Add commands to history immediately
setopt inc_append_history

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# =========================
# Directory Navigation
# =========================
# Change directory without cd command
setopt auto_cd

# Auto pushd when changing directories
setopt auto_pushd

# Remove duplicates from pushd
setopt pushd_ignore_dups

# =========================
# Completion Options
# =========================
# Display completion list when multiple candidates exist
setopt auto_list

# Mark file types like 'ls -F' in completion list
setopt list_types

# Auto correct command typos
setopt correct

# =========================
# Prompt
# =========================
autoload -U promptinit
promptinit

# Suggest correction with kawaii message
SPROMPT="( ´・ω・) ＜ %{$fg[blue]%}も%{${reset_color}%}%{$fg[red]%}し%{${reset_color}%}%{$fg[yellow]%}か%{${reset_color}%}%{$fg[green]%}し%{${reset_color}%}%{$fg[red]%}て%{${reset_color}%}: %{$fg[red]%}%r%{${reset_color}%}？ [(y)es,(n)o,(a)bort,(e)dit]
-> "

# =========================
# Completion Styles
# =========================
# Enable menu select mode with 2-column layout
zstyle ':completion:*:default' menu select=2

# Match uppercase characters in completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Colorize completion list
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

# =========================
# Additional Paths
# =========================
fpath=(/usr/local/share/zsh-completions ${fpath})

# =========================
# Zinit helpers
# =========================
zinit_update() {
  zinit update
  rm -f ~/.zcompdump*
  autoload -Uz compinit
  compinit
  zinit cdreplay
}

# Run on each shell start to avoid stale completion cache.
zinit cdreplay

# Load local zsh configuration (e.g., mise initialization)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# git-wt
# Why: eval "$(git wt --init zsh)" は毎回サブプロセス起動(34ms)。
# キャッシュファイルに保存し source で読み込むことで起動コストをほぼゼロにする。
_git_wt_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/git-wt-init.zsh"
if [[ ! -f "$_git_wt_cache" ]] || [[ -n "$_git_wt_cache"(#qN.mh+24) ]]; then
  mkdir -p "${_git_wt_cache:h}"
  git wt --init zsh > "$_git_wt_cache" 2>/dev/null
fi
source "$_git_wt_cache" 2>/dev/null
