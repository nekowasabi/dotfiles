# mise (runtime version manager) initialization
# Why: env/private.zsh ではなく common/ に配置 — zeno.zsh が deno (mise管理) を
# 必要とするため、zeno より前に mise activate を実行する必要がある。
# ============================================================

# Guard: 二重読み込み防止
[[ -n $_MISE_ZSH_LOADED ]] && return
_MISE_ZSH_LOADED=1

# mise バイナリの検出（環境に応じてパスが異なる）
local mise_bin=""
if [[ -x "/etc/profiles/per-user/${USER}/bin/mise" ]]; then
  # nix-darwin (macOS)
  mise_bin="/etc/profiles/per-user/${USER}/bin/mise"
elif command -v mise &>/dev/null; then
  # linuxbrew or other
  mise_bin="mise"
fi

if [[ -z "$mise_bin" ]]; then
  return
fi

# Why: --no-hook-env ではなく通常の activate を使用 — --no-hook-env だと activate 直後に
# PATH が更新されず、直後に読み込まれる zeno.zsh が deno を見つけられない。
# chpwd 境界での最適化は _mise_maybe_hook_env で別途行う。
eval "$($mise_bin activate zsh)"

# mise activate zsh が _mise_hook_chpwd / _mise_hook_precmd を自動登録するため、
# カスタムフック実装は不要。
