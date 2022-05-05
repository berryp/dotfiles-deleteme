#!/usr/bin/env bash

set -eo pipefail

configure_linux () {
  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile

  HOMEBREW_DEVELOPER=1 brew tap linuxbrew/fonts
  rm -rf ~/.local/share/fonts/fonts
  ln -s /home/linuxbrew/.linuxbrew/share/fonts ~/.local/share/fonts
  brew bundle
  fc-cache -fv

  [[ -n $GITPOD_WORKSPACE_ID ]] && configure_gitpod
}

configure_macos () {
  brew tap homebrew/cask-fonts
  brew bundle
}

configure_gitpod () {
  sudo tailscaled | tee ~/.tailscale.log & 
  sudo -E tailscale up --hostname "gitpod-${GITPOD_WORKSPACE_ID}" --authkey "${TAILSCALE_AUTHKEY}"
}

setup_neovim () {
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  nvim -es '+PlugInstall' '+qall' || true
}

setup_fish () {
  fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source \
    && fisher install jorgebucaran/fisher \
    && fisher fisher update'
}

if ! command -v brew &> /dev/null; then
  echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

setup_fish
