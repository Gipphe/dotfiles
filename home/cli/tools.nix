{ config, pkgs, ... }:
{
  programs = {
    bat = {
      enable = true;
      config = {
        pager = "less -FXR";
        theme = "TwoDark";
      };
    };

    direnv = {
      enable = true;
      config = {
        hide_env_diff = true;
      };
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      icons = true;
      git = true;
    };

    gh = {
      enable = true;
      settings = {
        editor = "";
        prompt = "enabled";
        pager = "";
        http_unix_socket = "";
        browser = "";
        git_protocol = "https";
        aliases = {
          co = "pr checkout";
          prc = "pr create -df";
          prm = "pr merge --auto -sd";
        };
      };
    };

    gpg.enable = true;

    htop.enable = true;

    jq.enable = true;

    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Victor Nascimento Bakke";
          email = "gipphe@gmail.com";
        };
        ui = {
          editor = "nvim";
          default-command = "lol";
        };
        git = {
          auto-local-branch = true;
        };
        aliases = {
          lol = [
            "log"
            "-r"
            "all()"
          ];
          sync = [
            "branch"
            "set"
            "-r"
            "@-"
          ];
        };
      };
    };

    lazygit.enable = true;

    less.enable = true;

    nnn.enable = true;

    ssh = {
      enable = true;
      package = pkgs.openssh;
      addKeysToAgent = "yes";
      matchBlocks = {
        "github.com" = {
          user = "git";
          identityFile = "${config.home.homeDirectory}/.ssh/github.ssh";
          identitiesOnly = true;
        };
        "gitlab.com" = {
          user = "git";
          identityFile = "${config.home.homeDirectory}/.ssh/gitlab.ssh";
          identitiesOnly = true;
        };
        "codeberg.com" = {
          user = "git";
          identityFile = "${config.home.homeDirectory}/.ssh/codeberg.ssh";
          identitiesOnly = true;
        };
      };
    };

    thefuck.enable = true;

    zoxide = {
      enable = true;
      options = [
        "--cmd"
        "cd"
      ];
    };

    vim = {
      enable = false;
      settings = {
        # Size of a hard tabstop
        tabstop = 4;
        # Size of an 'indent'
        shiftwidth = 4;
        # always use tabs instead of spaces
        expandtab = false;
      };
      extraConfig = ''
        scriptencoding utf-8
        set encoding=utf-8

        " A combination of spaces and tabs are used to simulate tab stops at a width
        " other than the (hard)tabstop
        set softtabstop=0

        set list listchars=tab:▸\ ,trail:·,precedes:←,extends:→

        if exists('+colorcolumn')
          set colorcolumn=100
        else
          au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>100v.\+', -1)
        endif
      '';
    };
  };
}
