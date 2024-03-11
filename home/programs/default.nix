{ pkgs, ... }: {
  imports = [ ./git ./neovim ./fish ./tmux ./tmux ];
  programs.zoxide.enable = true;
  programs.gpg.enable = true;
  programs.eza = {
    enable = true;
    enableAliases = true;
    icons = true;
    git = true;
  };
  programs.jq.enable = true;
  programs.thefuck.enable = true;
  programs.ssh = {
    enable = true;
    package = pkgs.openssh;
    addKeysToAgent = "yes";
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = ~/.ssh/github.ssh;
        identitiesOnly = true;
        # strictHostKeyChecking yes
      };

      "gitlab.com" = {
        user = "git";
        identityFile = ~/.ssh/gitlab.ssh;
        identitiesOnly = true;
        # StrictHostKeyChecking yes
      };

      "codeberg.com" = {
        user = "git";
        identityFile = ~/.ssh/codeberg.ssh;
        identitiesOnly = true;
        # StrictHostKeyChecking yes
      };
    };
  };
  programs.lazygit.enable = true;
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
  programs.gh = {
    enable = true;
    settings = {
      aliases = {
        co = "pr checkout";
        prc = "pr create -df --assignee @me";
        prm = "pr merge -sd --auto";
      };
    };
  };
  programs.htop.enable = true;
}
