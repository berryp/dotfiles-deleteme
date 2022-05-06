{ config, pkgs, libs, ... }:
{
  programs.fish = {
    enable = true;
    plugins = [
      # Need this when using Fish as a default macOS shell in order to pick
      # up ~/.nix-profile/bin
      {
        name = "iterm2-shell-integration";
        src = ./config/fish/iterm2_shell_integration;
      }
      {
        name = "fish-kubectl-completions";
        src = pkgs.fetchFromGitHub {
          owner = "evanlucas";
          repo = "fish-kubectl-completions";
          rev = "ced676392575d618d8b80b3895cdc3159be3f628";
          sha256 = "sha256-OYiYTW+g71vD9NWOcX1i2/TaQfAg+c2dJZ5ohwWSDCc";
        };
      }
      # Need this when using Fish as a default macOS shell in order to pick
      # up ~/.nix-profile/bin
      {
        name = "nix-env";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "00c6cc762427efe08ac0bd0d1b1d12048d3ca727";
          sha256 = "1hrl22dd0aaszdanhvddvqz3aq40jp9zi2zn0v1hjnf7fx4bgpma";
        };
      }
    ];
    shellInit = ''
      # Set syntax highlighting colours; var names defined here:
      # http://fishshell.com/docs/current/index.html#variables-color
      set fish_color_normal normal
      set fish_color_command white
      set fish_color_quote brgreen
      set fish_color_redirection brblue
      set fish_color_end white
      set fish_color_error -o brred
      set fish_color_param brpurple
      set fish_color_comment --italics brblack
      set fish_color_match cyan
      set fish_color_search_match --background=brblack
      set fish_color_operator cyan
      set fish_color_escape white
      set fish_color_autosuggestion brblack
    '';
    interactiveShellInit = ''
      # Activate the iTerm 2 shell integration
      iterm2_shell_integration
      # Pick up conda installation
      if test -x /Users/apearce/.mambaforge/bin/conda
        eval /Users/apearce/.mambaforge/bin/conda "shell.fish" "hook" $argv | source
      end
    '';
    shellAliases = {
      nvim = "nvim -p";
      vim = "nvim -p";
      vi = "nvim -p";
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
      mkdir = "mkdir -p";
      du = "du -hs";
    };
    shellAbbrs = {
      g = "git";
      ga = "git add";
      gap = "git add -p";
      gb = "git branch";
      gc = "git commit";
      gcan = "git commit --amend --no-edit";
      gcm = "git commit -m";
      gcl = "git clone";
      gd = "git diff";
      gds = "git diff --staged";
      gl = "git prettylog";
      gp = "git push";
      gpf = "git push -f";
      gr = "git restore";
      grb = "git rebase";
      grba = "git rebase --abort";
      grbc = "git rebase --continue";
      grbi = "git rebase -i";
      gs = "git status -s -b";
      gst = "git stash";
      gstp = "git stash pop";
      gsts = "git stash show -p";
      gstx = "git stash drop";
      gsw = "git switch";
      gswc = "git switch -c";
      hme = "home-manager edit";
      hms = "home-manager switch";
      k = "kubectl";
      ka = "kubectl apply -f";
      kcgc = "kubectl config get-contexts";
      kcuc = "kubectl config use-context";
      kd = "kubectl describe";
      kg = "kubectl get";
      kl = "kubectl logs";
      kr = "kubectl run -i --tty";
      m = "make";
      n = "nvim";
      o = "open";
      p = "python3";
    };
    functions = {
      ctrlp = {
        description = "Launch Neovim file finder from the shell";
        argumentNames = "hidden";
        body = ''
          if test -n "$hidden"
            nvim -c 'lua require(\'telescope.builtin\').find_files({hidden = true})'
          else
            nvim -c 'lua require(\'telescope.builtin\').find_files()'
          end
        '';
      };
      fish_user_key_bindings = {
        description = "Set custom key bindings";
        body = ''
          bind \cp ctrlp
          bind \cl 'ctrlp --hidden'
        '';
      };
      nvimrg = {
        description = "Open files matched by ripgrep with Neovim";
        body = "nvim (rg -l $argv) +/\"$argv[-1]\"";
      };
      fish_greeting = {
        description = "Greeting to show when starting a fish shell";
        body = "";
      };
      mkdcd = {
        description = "Make a directory tree and enter it";
        body = "mkdir -p $argv[1]; and cd $argv[1]";
      };
    };
  };
}