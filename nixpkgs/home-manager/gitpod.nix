{ config, pkgs, ... }:

{
  home.stateVersion = "22.05";

  home.username = "gitpod";
  home.homeDirectory = "/home/gitpod";

  home.packages = with pkgs; [
    fishPlugins.foreign-env
  ];

  # disable gpg signing on Gitpod since there's
  # no easy way to forward the gpg-agent
  programs.git.signing.signByDefault = false;
}
