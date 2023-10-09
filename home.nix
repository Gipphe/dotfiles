{ config, pkgs, lib, nixpkgs, ... }:

let
  omzThemeName = "headline";
  omzTheme = builtins.fetchGit {
    owner = "moarram";
    repo = omzThemeName;
    rev = "c12368adfbbaa35e7f21e743d34b59f8db263a95";
    hash = lib.fakeHash;
  };
  omz = ~/.oh-my-zsh;
  omzCustom = "${omz}/custom";
  linux = [ ./env/linux/packages.nix ];
  darwin = [ ./env/darwin/packages.nix ];
  envs = {
    inherit linux;
    inherit darwin;
  };
in {
  imports = [ ./env/common/packages.nix ] ++ envs."${system}";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ (import ./overlays/jujutsu.nix) ];
  font.fontconfig.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "gipphe";
  home.homeDirectory = "/home/gipphe";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs;
    [
      # # Adds the 'hello' command to your environment. It prints a friendly
      # # "Hello, world!" when run.
      # pkgs.hello

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')

    ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".jjconfig.toml".source = ./config/.jjconfig.toml;
    "${omzCustom}/headline.zsh-theme".source =
      "${omzTheme.outPath}/headline.zsh-theme";
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
  home.sessionVariables = {
    EDITOR = "vim";
    PAGER = "less -F -X";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
      theme = "TwoDark";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.gh = {
    enable = true;
    settings = {
      aliases = {
        prc = "pr create -df";
        prm = "pr merge --auto -sd";
      };
      git_protocol = "ssh";
    };
  };

  programs.git = {
    enable = true;
    userName = "Victor Nascimento Bakke";
    userEmail = "gipphe@gmail.com";
    aliases = {
      last = "log -1 HEAD";
      st = "status";
      ch = "checkout";
      fa = "fetch --all --prune";
      ba = "branch -a";
      b = "branch";
      co = "commit";
      cp = "cherry-pick";
      pp = "pull --prune";
      gr = ''
        log --graph --full-history --all --color --pretty=format:\"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s\"'';
      lol = "log --decorate --oneline --graph --all";
      lof = "log --oneline --decorate --all --graph --first-parent";
      loa = "log --decorate --oneline --graph";
      lob = "log --decorate --oneline --graph --first-parent";

      stage = "add";
      unstage = "restore --staged";

      #
      # Aliases from robmiller's gist
      # See https://gist.github.com/robmiller/6018582
      #
      # Working with branches
      #

      # Get the current branch name (not so useful in itself, but used in
      # other aliases)
      branch-name = "!git rev-parse --abbrev-ref HEAD";
      bn = "!git branch-name";
      # Push the current branch to the remote "origin", and set it to track
      # the upstream branch
      publish = "!git push -u origin $(git branch-name)";
      pub = "!git publish";
      # Delete the remote version of the current branch
      unpublish = "!git push origin :$(git branch-name)";
      unpub = "!git unpublish";
      # Delete a branch and recreate it from master — useful if you have, say,
      # a development branch and a master branch and they could conceivably go
      # out of sync
      recreate = ''
        !f() { [[ -n $@ ]] && git checkout \"$@\" && git unpublish && git checkout master && git branch -D \"$@\" && git checkout -b \"$@\" && git publish; }; f'';
      "rec" = "!git recreate";

      # Fire up your difftool (e.g. Kaleidescope) with all the changes that
      # are on the current branch.
      code-review = "difftool origin/master...";
      cr = "!git code-review";

      # Given a merge commit, find the span of commits that exist(ed) on that
      # branch. Again, not so useful in itself, but used by other aliases.
      merge-span =
        "!f() { echo $(git log -1 $2 --merges --pretty=format:%P | cut -d' ' -f1)$1$(git log -1 $2 --merges --pretty=format:%P | cut -d' ' -f2); }; f";

      # Find the commits that were introduced by a merge
      merge-log = "!git log $(git merge-span .. $1)";
      ml = "!git merge-log";
      # Show the changes that were introduced by a merge
      merge-diff = "!git diff $(git merge-span ... $1)";
      md = "!git merge-diff";
      # As above, but in your difftool
      merge-difftool = "!git difftool $(git merge-span ... $1)";
      mdt = "!git merge-difftool";

      # Interactively rebase all the commits on the current branch
      rebase-branch = "!git rebase -i $(git merge-base master HEAD)";
      rb = "!git rebase-branch";

      #
      # Working with files
      #

      # Unstage any files that have been added to the staging area
      unstage-all = "reset HEAD";
      unst = "!git unstage";
      # Show changes that have been staged
      diffc = "diff --cached";

      # Mark a file as "assume unchanged", which means that Git will treat it
      # as though there are no changes to it even if there are. Useful for
      # temporary changes to tracked files
      assume = "update-index --assume-unchanged";
      ass = "!git assume";
      # Reverse the above
      unassume = "update-index --no-assume-unchanged";
      unass = "!git unassume";
      # Show the files that are currently assume-unchanged
      assumed = "!git ls-files -v | grep ^h | cut -c 3-";
      assd = "!git assumed";

      # Checkout our version of a file and add it
      ours = "!f() { git checkout --ours $@ && git add $@; }; f";
      # Checkout their version of a file and add it
      theirs = "!f() { git checkout --theirs $@ && git add $@; }; f";

      # Delete any branches that have been merged into master
      # See also: https://gist.github.com/robmiller/5133264
      delete-merged-branches =
        "!git checkout master && git branch --merged | grep -v '\\\\*' | xargs -n 1 git branch -d";

      rm-merged = ''
        !git branch --format '%(refname:short) %(upstream:track)' | awk '$2 == \"[gone]\" { print $1 }' | xargs -r git branch -D'';

      # Checkout a merge request locally
      mr =
        "!sh -c 'git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2' -";
    };
    delta.enable = true;
    ignores = [ ".vscode" "**/*Zone.Identifier" ".envrc" ];
    includes = [{
      condition = "gitdir:**/strise/**/.git";
      contents = {
        user = {
          name = "Victor Nascimento Bakke";
          email = "victor@strise.ai";
          signingkey = "B4C7E23DDC6AE725";
        };
      };
    }];
    signing = {
      key = "23723701395B436C";
      signByDefault = true;
    };
    userEmail = "gipphe@gmail.com";
    userName = "Victor Nascimento Bakke";
    extraConfig = {
      "url \"git@github.com:\"" = { insteadOf = "https://github.com/"; };
      push = {
        default = "simple";
        followTags = true;
      };
      core = {
        safecrlf = false;
        autocrlf = false;
        eol = "lf";
        editor = "vim";
        pager = "less -F -X";
      };
      credential = { credentialStore = "gpg"; };
      init = { defaultBranch = "main"; };
    };
  };

  programs.gpg.enable = true;
  programs.jq.enable = true;

  programs.kitty.enable = true;

  programs.less.enable = true;

  programs.ssh = {
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

  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
  };

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

  programs.zsh = {
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

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  services.ssh-agent.enable = true;
}
