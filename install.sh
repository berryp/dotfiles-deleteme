#!/usr/bin/env bash

set -ex

link_files() {
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
      rm -rf $dest
    fi

    ln -fs "$PWD/$file" "$HOME/$file"
  done
}

if [ -n $GITPOD_WORKSPACE_ID ]; then
  link_files()

  # We're in Gitpod
  { 
    sudo tailscaled &> ~/.tailscale.log & 
    sudo -E tailscale up --hostname "gitpod-${GITPOD_WORKSPACE_ID}" --authkey "${TAILSCALE_AUTHKEY}"
  }
fi


sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

nvim -es '+PlugInstall' '+qall' || true

if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

