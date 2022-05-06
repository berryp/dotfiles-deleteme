#!/usr/bin/env bash

set -eo pipefail

dotfiles_dir="$HOME/.dotfiles"

if [ -d /nix ]; then
  mkdir -p ~/.config

  rm -rf ~/.config/nixpkgs
  ln -s "$dotfiles_dir/nixpkgs" ~/.config || true

  # nix-env -iA nixpkgs.nixFlakes

  export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install

  rm ~/.config/nixpkgs/home.nix

  home-manager switch --fkake .#gitpod
fi

setup_gitpod () {
  echo "Ignore Gitpod for now"
  # sudo tailscaled | tee ~/.tailscale.log &
  # sudo -E tailscale up --hostname "gitpod-${GITPOD_WORKSPACE_ID}" --authkey "${TAILSCALE_AUTHKEY}"
}

[[ -n $GITPOD_WORKSPACE_ID ]] && setup_gitpod
