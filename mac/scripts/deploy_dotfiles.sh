#!/bin/bash

cd ~/repos/dotfiles/vim_integrate
cp -rfv coc-settings.json init.vim rc mysnippet syntax ~/.config/nvim
cd ~/repos/dotfiles
cp -rfv ./zeno/* ~/.config/zeno

# 引数がprivateの場合はprivateディレクトリにコピー
if [ "$1" = "private" ]; then
  cp -rfv ~/repos/dotfiles/lazygit/* ~/Library/Application\ Support/lazygit
  cp -rfv ~/repos/dotfiles/zsh/mac_zshrc ~/.zshrc 
  cp -rfv ~/repos/dotfiles/mac/mac_wezterm.lua ~/.wezterm.lua 
  cp -rfv ~/repos/dotfiles/mac/scripts/* ~/scripts

  cp -rfv ~/repos/dotfiles/mac/superwhisper/* ~/Documents/superwhisper
fi

if [ "$1" = "private" ]; then
  cp -rfv ~/repos/dotfiles/lazygit/* ~/Library/Application\ Support/lazygit
  cp -rfv ~/repos/dotfiles/zsh/mfs_zshrc ~/.zshrc 
  cp -rfv ~/repos/dotfiles/mac/mfs_wezterm.lua ~/.wezterm.lua 
  cp -rfv ~/repos/dotfiles/mac/scripts/* ~/scripts

  cp -rfv ~/repos/private_dotfiles/mac/superwhisper/* ~/Documents/superwhisper
fi

if [ "$1" = "wsl" ]; then
  cp -rfv ~/repos/dotfiles/zsh/wsl_zshrc ~/.zshrc 
  cp -rfv ~/repos/dotfiles/mac/wsl_wezterm.lua ~/.wezterm.lua 
fi

cd ~/
