#!/bin/bash

cd ~/.config/nvim && cp -rfv coc-settings.json init.vim rc mysnippet syntax ~/repos/dotfiles/vim_integrate
cp -rfv ~/.config/zeno/* ~/repos/dotfiles/zeno

# 引数がprivateの場合はprivateディレクトリにコピー
if [ "$1" = "private" ]; then
  cp -rfv ~/Library/Application Support/lazygit/* ~/repos/dotfiles/lazygit
  cp -rfv ~/.zshrc ~/repos/dotfiles/zsh/mac_zshrc
  cp -rfv ~/.wezterm.lua ~/repos/dotfiles/mac/mac_wezterm.lua
  cp -rfv ~/Dropbox/Keyboard Maestro Macros.kmsync ~/repos/dotfiles/mac
  # cp -rfv ~/scripts ~/repos/dotfiles/mac/

  cd ~/Documents/superwhisper
  cp -rfv models settings ~/repos/private_dotfiles/mac/superwhisper
fi

if [ "$1" = "mfs" ]; then
  cp -rfv ~/Library/Application Support/lazygit/* ~/repos/dotfiles/lazygit
  cp -rfv ~/.zshrc ~/repos/dotfiles/zsh/mfs_zshrc
  cp -rfv ~/.wezterm.lua ~/repos/dotfiles/mac/mfs_wezterm.lua
  cp -rfv ~/scripts ~/repos/dotfiles/mac/

  cd ~/Documents/superwhisper
  cp -rfv models settings ~/repos/private_dotfiles/mac/superwhisper
fi

if [ "$1" = "wsl" ]; then
  cp -rfv ~/.zshrc ~/repos/dotfiles/zsh/wsl_zshrc
  cp -rfv ~/.wezterm.lua ~/repos/dotfiles/mac/wsl_wezterm.lua
fi

cd ~/repos/dotfiles
git add .  && lazygit

cd ~/repos/private_dotfiles
git add .  && lazygit

cd ~/
