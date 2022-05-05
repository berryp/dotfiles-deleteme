#!/usr/bin/env bash

set -eo pipefail

link_files () {
  files=(
    ".gitconfig"
    ".tmux.conf"
    ".tmux.conf.macos"
    ".tmux.conf.powerline"
    ".config/fish"
    ".config/nvim"
  )

  mkdir -p "$HOME/.config"

  for file in "${files[@]}"; do
    dest="$HOME/$file"
    echo "Linking $file → $dest"

    if [ -e "$dest" ]; then
      rm -rf "$dest"
    fi

    ln -fs "$PWD/$file" "$HOME/$file"
  done
}

setup_gitpod () {
  link_files
  (
    sudo tailscaled | tee ~/.tailscale.log & 
    sudo -E tailscale up --hostname "gitpod-${GITPOD_WORKSPACE_ID}" --authkey "${TAILSCALE_AUTHKEY}"
  )
}

setup_linux () {
  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile

  [[ -n $GITPOD_WORKSPACE_ID ]] && setup_gitpod
}

OS="$(uname)"
case $OS in
  'Linux')
    setup_linux
    ;;
  'Darwin') ;;
  *) ;;
esac

