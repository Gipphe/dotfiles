{ lib, ... }:
with lib;
let
  inherit (attrsets) filterAttrs;
  machineConfig = let
    thisMachine = readFile ./machineName;
    machineNames = filterAttrs (_: v: v == "directory") (readDir ./machines);
    machines = foldl' (l: m: l // { "${m}" = ./machines/${m}/default.nix; }) { }
      machineNames;
  in machines.${thisMachine};
in {
  extraSpecialArgs = { inherit machineConfig; };

  nixpkgs.config.allowUnfree = true;
  font.fontconfig.enable = true;

  home = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = "gipphe";
    homeDirectory = "/home/gipphe";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    # You can also manage environment variables but you will have to manually
    # source
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/gipphe/etc/profile.d/hm-session-vars.sh
    #
    # if you don't want to manage your shell through Home Manager.
    sessionVariables = {
      EDITOR = "nvim";
      PAGER = "less -FXR";
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    bat = {
      enable = true;
      config = {
        pager = "less -FXR";
        theme = "TwoDark";
      };
    };

    direnv = {
      enable = true;
      enableFishIntegration = true;
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
          prc = "pr create -df";
          prm = "pr merge --auto -sd";
        };
      };
    };

    gpg.enable = true;
    jq.enable = true;

    kitty.enable = true;

    less.enable = true;

    ssh = {
      enable = true;
      matchBlocks = {
        "github.com-strise" = lib.hm.dag.entryBefore [ "github.com" ] {
          hostname = "github.com";
          user = "git";
          identitiesOnly = true;
          identityFile = "~/.ssh/id_rsa.strise";
        };

        "github.com" = {
          hostname = "github.com";
          user = "git";
          identitiesOnly = true;
          identityFile = "~/.ssh/id_rsa.github";
        };

        "gitlab.com" = {
          hostname = "gitlab.com";
          user = "git";
          identitiesOnly = true;
          identityFile = "~/.ssh/id_rsa.gitlab";
        };
      };
    };

    tmux = {
      enable = true;
      mouse = true;
      clock24 = true;
    };

    vim = {
      enable = true;
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

    zsh = {
      enable = true;
      enableAutoSuggestions = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "stack" "docker" "docker-compose" ];
        theme = omzThemeName;
        custom = omzCustom;
      };
    };
  } // env.programs;

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    ssh-agent.enable = true;
  };
}
