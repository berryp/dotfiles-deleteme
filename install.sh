#!/usr/bin/env bash

set -eo pipefail

if [ -e /nix]; then
  NIX_DIR="$HOME/.config/nixpkgs"
  mkdir -p "$NIX_DIR"
  ln -s "$PWD/config" "$NIX_DIR" || true
  envsubst < home.nix > "$NIX_DIR/home.nix"
  home-manager switch
fi

setup_gitpod () {
  echo "Ignore Gitpod for now"
  # sudo tailscaled | tee ~/.tailscale.log &
  # sudo -E tailscale up --hostname "gitpod-${GITPOD_WORKSPACE_ID}" --authkey "${TAILSCALE_AUTHKEY}"
}

[[ -n $GITPOD_WORKSPACE_ID ]] && setup_gitpod
