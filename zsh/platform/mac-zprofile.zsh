# Prefer ~/.grok/bin over Homebrew cask grok.
# Sourced from ~/.zprofile (login) and platform/mac.zsh (every zshrc, including reload).
# Why: Instead of PATH-prepend only at the end of env/private.zsh, also unshift
# here and alias the binary. Reason: env/private.zsh returns early on reload
# ($_PRIVATE_ZSH_LOADED), and nested tmux zsh leaves /opt/homebrew/bin ahead of
# ~/.grok/bin (verified on the launching shell: homebrew at PATH[58], grok at [61]).
if [[ -x "$HOME/.grok/bin/grok" ]]; then
  path=("$HOME/.grok/bin" ${path:#$HOME/.grok/bin})
  alias grok="$HOME/.grok/bin/grok"
  unhash grok 2>/dev/null || true
fi
