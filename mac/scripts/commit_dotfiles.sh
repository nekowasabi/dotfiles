#!/bin/bash

cd ~/.config/nvim && cp -rfv coc-settings.json init.vim rc mysnippet syntax ~/repos/dotfiles/vim_integrate
cp -rfv ~/.config/zeno/* ~/repos/dotfiles/zeno
cp -rfv ~/Library/Application Support/lazygit/* ~/repos/dotfiles/lazygit

# 引数がprivateの場合はprivateディレクトリにコピー
if [ "$1" = "private" ]; then
  cp -rfv ~/.zshrc ~/repos/dotfiles/zsh/mac_zshrc
  cp -rfv ~/.wezterm.lua ~/repos/dotfiles/mac/mac_wezterm.lua
  cp -rfv ~/scripts ~/repos/dotfiles/mac/
fi

cd ~/repos/dotfiles
git add .  && lazygit

cd ~/repos/private_dotfiles
git add .  && lazygit

cd ~/
