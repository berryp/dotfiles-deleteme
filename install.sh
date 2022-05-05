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

setup_linux () {
  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile
  brew tap linuxbrew/fonts
  ln -s /home/linuxbrew/.linuxbrew/share/fonts ~/.local/share/fonts
  brew bundle
  fc-cache -fv
}

setup_macos () {
  brew tap homebrew/cask-fonts
  brew bundle
}

setup_gitpod () {
  link_files
  (
    sudo tailscaled | tee ~/.tailscale.log & 
    sudo -E tailscale up --hostname "gitpod-${GITPOD_WORKSPACE_ID}" --authkey "${TAILSCALE_AUTHKEY}"
  )
}

setup_neovim () {
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  nvim -es '+PlugInstall' '+qall' || true
}

if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

OS="$(uname)"
case $OS in
  'Linux')
    OS='Linux'
    setup_linux
    ;;
  'Darwin') 
    OS='macOS'
    setup_macos
    ;;
  *)
    [[ -n $GITPOD_WORKSPACE_ID ]] && setup_gitpod
    ;;
esac

# FZF
"$(brew --prefix fzf)"/install --key-bindings --completion --update-rc

setup_neovim

