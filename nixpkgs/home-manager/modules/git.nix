{ config, pkgs, lib, libs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Berry Phillips";
    userEmail = "berryphillips@gmail.com";
    aliases = {
      prettylog = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
      st = "status";
      co = "checkout";
      ci = "commit";
    };
    extraConfig = {
      core = {
        editor = "nvim";
        # https://github.com/NixOS/nixpkgs/issues/15686#issuecomment-865928923
        sshCommand = "/usr/bin/ssh";
      };
      color = {
        ui = true;
      };
      push = {
        default = "simple";
      };
      pull = {
        ff = "only";
      };
      init = {
        defaultBranch = "main";
      };
    };
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        syntax-theme = "GitHub";
      };
    };
    ignores = [
      ".DS_Store"
      ".envrc"
      ".*.swp"
    ];
  };
}