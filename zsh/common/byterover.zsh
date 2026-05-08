# ByteRover CLI (brv)
# Why: install.sh は ~/.zshrc に PATH 追記するが、nix(home-manager)管理のため
# 直接編集不可。dotfiles 側で同等の PATH 設定を行う。
# Why: $PC=wsl / private のみで有効化（work 環境では brv を使わないため）
case "$PC" in
  wsl|private)
    [[ -d "$HOME/.brv-cli/bin" ]] && export PATH="$HOME/.brv-cli/bin:$PATH"
    ;;
esac
