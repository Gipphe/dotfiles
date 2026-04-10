{
  inputs,
  lib,
  config,
  pkgs,
  util,
  ...
}:
let
  # Public key for secrets/pub-git-ssh-signing-key.key
  allowedSignersFile = pkgs.writeText "git_allowed_signers" ''
    gipphe@gmail.com namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINzkW4CGcY2zjXnWx1o7uy85D0O7OvjzTa51GLtA0uQv
    victor.bakke@tweag.io namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINzkW4CGcY2zjXnWx1o7uy85D0O7OvjzTa51GLtA0uQv
  '';
  ignoreFile = pkgs.writeText "git_ignore" /* gitignore */ ''
    .DS_Store
    **/*Zone.Identifier
    .idea/
    .vscode/
    Session.vim
    .claude/*.local.*
  '';
in
util.mkProgram {
  name = "git";
  hm = {
    options.gipphe.programs.git = {
      package = lib.mkPackageOption pkgs "git" { } // {
        default = config.wrappers.git.package;
      };
    };
    imports = [
      (inputs.wlib.lib.mkInstallModule {
        loc = [
          "home"
          "packages"
        ];
        name = "git";
        value = inputs.wlib.lib.wrapperModules.git;
      })
      ./lfs.nix
      ./diff-so-fancy.nix
    ];
    config = {
      gipphe.programs.git = {
        lfs.enable = true;
        diff-so-fancy.enable = true;
      };

      wrappers.git = {
        enable = true;
        configFile.content = /* ini */ ''
          [credential "https://gist.github.com"]
            helper = ""
            helper = "${lib.getExe pkgs.gh} auth git-credential"

          [credential "https://github.com"]
            helper = ""
            helper = "${lib.getExe pkgs.gh} auth git-credential"
        '';
        settings = {
          branch.autosetupmerge = "true";
          core = {
            safecrlf = false;
            autocrlf = false;
            eol = "lf";
            editor = "nvim";
            whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
            excludesFile = ignoreFile.outPath;
          };
          credential.credentialStore = "gpg";
          user = {
            name = "Victor Nascimento Bakke";
            email = "gipphe@gmail.com";
            signingKey = config.sops.secrets.git-signing-key.path;
          };
          commit.gpgSign = true;
          tag.gpgSign = true;
          gpg = {
            format = "ssh";
            ssh = {
              program = lib.getExe' pkgs.openssh "ssh-keygen";
              allowedSignersFile = allowedSignersFile.outPath;
            };
          };
          push = {
            default = "upstream";
            followTags = true;
          };
          pull.ff = "only";
          repack.usedeltabaseoffset = "true";
          rebase.autoSquash = "true";
          merge.stat = "true";
          init.defaultBranch = "main";
          rerere = {
            enabled = true;
            autoUpdate = true;
          };
          alias = {
            # Pure laziness
            st = "status";
            sw = "switch";
            fa = "fetch --all --prune";
            ba = "branch -a";
            b = "branch";
            co = "checkout";
            ci = "commit";
            cp = "cherry-pick";
            pp = "pull --prune";
            p = "push";
            puf = "push --force-with-lease";

            # Log views
            last = "log -1 HEAD";
            lol = "log --decorate --oneline --graph --all";
            lof = "log --oneline --decorate --all --graph --first-parent";
            loa = "log --decorate --oneline --graph";
            lob = "log --decorate --oneline --graph --first-parent";
            lolb = ''log --graph --pretty=format:"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'';
            lola = "lolb --all";
            lold = ''log --graph --pretty=format:"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'';
            loldr = "lold --date=short";

            # Semantic naming for add and restore
            stage = "add";
            unstage = "restore --staged";

            # Get the current branch name (not so useful in itself, but used in
            # other aliases)
            branch-name = "!git rev-parse --abbrev-ref HEAD";
            # Push the current branch to the remote "origin", and set it to track
            # the upstream branch
            publish = "!git push -u origin $(git branch-name)";
            pub = "!git publish";
            # Delete the remote version of the current branch
            unpublish = "!git push origin :$(git branch-name)";
            unpub = "!git unpublish";

            # Show changes that have been staged
            diffc = "diff --cached";

            gone = ''!git branch --format '%(refname:short) %(upstream:track)' | awk '$2 == "[gone]" { print $1 }' | xargs -r git branch -D'';
          };
        };
      };

      sops.secrets.git-signing-key = {
        sopsFile = ../../../secrets/pub-git-ssh-signing-key.key;
        format = "binary";
      };
    };
  };
}
