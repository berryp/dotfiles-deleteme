#!/usr/bin/env bash

set -eo pipefail

configure_linux () {
  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile

  brew tap linuxbrew/fonts
  ln -s /home/linuxbrew/.linuxbrew/share/fonts ~/.local/share/fonts
  brew bundle
  fc-cache -fv

  [[ -n $GITPOD_WORKSPACE_ID ]] && setup_gitpod
}

configure_macos () {
  brew tap homebrew/cask-fonts
  brew bundle
}

configure_gitpod () {
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
    configure_linux
    ;;
  'Darwin') 
    configure_macos
    ;;
  *) ;;
esac

# FZF
"$(brew --prefix fzf)"/install --key-bindings --completion --update-rc

setup_neovim

