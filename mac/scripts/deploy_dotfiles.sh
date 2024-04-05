#!/bin/bash

cd ~/repos/dotfiles/vim_integrate
cp -rfv coc-settings.json init.vim rc mysnippet syntax ~/.config/nvim
cd ~/repos/dotfiles
cp -rfv ./zeno/* ~/.config/zeno
cp -rfv ~/repos/dotfiles/lazygit/* ~/Library/Application Support/lazygit

# 引数がprivateの場合はprivateディレクトリにコピー
if [ "$1" = "private" ]; then
  cp -rfv ~/repos/dotfiles/zsh/mac_zshrc ~/.zshrc 
  cp -rfv ~/repos/dotfiles/mac/mac_wezterm.lua ~/.wezterm.lua 
  cp -rfv ~/repos/dotfiles/mac/scripts/* ~/scripts
fi

cd ~/
