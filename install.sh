#!/usr/bin/env bash

set -e

files=(
  ".gitconfig"
  ".tmux.conf"
  ".tmux.conf.macos"
  ".tmux.conf.powerline"
  ".config/fish"
  ".config/nvim"
)

mkdir -p "$HOME/.config"

for file in ${files[@]}; do
  dest="$HOME/$file"
  echo "Linking $file → $dest"
  if [ -e $dest ]; then
    echo "  File exists... skipping"
    continue
  fi

  ln -fs "$PWD/$file" "$HOME/$file"
done

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

nvim -es '+PlugInstall' '+qall'

