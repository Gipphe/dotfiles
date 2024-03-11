{ config, pkgs, ... }: {
  imports = [ ./git ./neovim ./fish ./tmux ./tmux ];

  programs.bat = {
    enable = true;
    config = {
      pager = "less -FXR";
      theme = "TwoDark";
    };
  };

  programs.direnv.enable = true;

  programs.eza = {
    enable = true;
    enableAliases = true;
    icons = true;
    git = true;
  };

  programs.gh = {
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

  programs.gpg.enable = true;

  programs.htop.enable = true;

  programs.jq.enable = true;

  programs.jujutsu = {
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
      git = { auto-local-branch = true; };
      aliases = {
        lol = [ "log" "-r" "all()" ];
        sync = [ "branch" "set" "-r" "@-" ];
      };
    };
  };

  programs.lazygit.enable = true;

  programs.less.enable = true;

  programs.ssh = {
    enable = true;
    package = pkgs.openssh;
    addKeysToAgent = "yes";
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "${config.home.homeDirectory}/.ssh/github.ssh";
        identitiesOnly = true;
        # strictHostKeyChecking yes 
      };
      "gitlab.com" = {
        user = "git";
        identityFile = "${config.home.homeDirectory}/.ssh/gitlab.ssh";
        identitiesOnly = true;
        #StrictHostKeyChecking yes
      };
      "codeberg.com" = {
        user = "git";
        identityFile = "${config.home.homeDirectory}/.ssh/codeberg.ssh";
        identitiesOnly = true;
        # StrictHostKeyChecking yes 
      };
    };
  };

  programs.thefuck.enable = true;

  programs.zoxide.enable = true;

  programs.vim = {
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
}
