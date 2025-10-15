{
  lib,
  config,
  pkgs,
  util,
  ...
}:
util.mkProgram {
  name = "git";
  options.gipphe.programs.git = {
    package = lib.mkPackageOption pkgs "git" { } // {
      default = config.programs.git.package;
    };
    windows = {
      config = lib.mkOption {
        description = "Config to be used on Windows";
        type = lib.types.package;
        internal = true;
      };
      ignores = lib.mkOption {
        description = "Git ignore for Windows";
        type = lib.types.path;
        internal = true;
      };
    };
  };
  hm = {
    home.packages =
      let
        ci = util.writeFishApplication {
          name = "ci";
          runtimeInputs = [
            pkgs.gum
            config.programs.git.package
          ];
          text = # bash
            ''
              if test (count $argv) != 0
                echo "This script expects no arguments" >&2
                exit 1
              end

              set -l type $(gum choose "fix" "feat" "refactor" "docs" "test" "style" "chore" "revert")
              or exit $status
              set -l scope $(gum input --placeholder "scope")
              or exit $status

              if test -n "$scope"
                set scope "($scope)"
              end

              set -l summary $(gum input --value "$type$scope: " --placeholder "Summary of this change.")
              or exit $status
              set -l description $(gum write --placeholder "Details of this change.")
              or exit $status

              gum confirm "Commit changes?" && git commit -m "$summary" -m "$description"
              or exit $status
            '';
        };
        commit = pkgs.linkFarm "commit" [
          {
            name = "bin/commit";
            path = lib.getExe ci;
          }
        ];
      in
      [
        ci
        commit
      ];

    sops.secrets.git-signing-key = {
      sopsFile = ../../../secrets/pub-git-ssh-signing-key.key;
      format = "binary";
    };
    # Public key for secrets/pub-git-ssh-signing-key.key
    xdg.configFile."git/allowed_signers".text = ''
      gipphe@gmail.com namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINzkW4CGcY2zjXnWx1o7uy85D0O7OvjzTa51GLtA0uQv
      victor.bakke@tweag.io namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINzkW4CGcY2zjXnWx1o7uy85D0O7OvjzTa51GLtA0uQv
    '';
    programs.git = {
      enable = true;
      userName = "Victor Nascimento Bakke";
      userEmail = "gipphe@gmail.com";
      diff-so-fancy.enable = true;
      ignores = [
        ".DS_Store"
        "**/*Zone.Identifier"
        ".idea/"
        ".vscode/"
      ];
      signing = {
        format = "ssh";
        key = config.sops.secrets.git-signing-key.path;
        signByDefault = true;
      };
      includes = [
        {
          condition = "gitdir:~/projects/tweag";
          contents.user.email = "victor.bakke@tweag.io";
        }
        {
          condition = "gitdir:~/projects/modus-create";
          contents.user.email = "victor.bakke@tweag.io";
        }
      ];
      extraConfig = {
        push = {
          default = "upstream";
          followTags = true;
        };
        pull.ff = "only";
        core = {
          safecrlf = false;
          autocrlf = false;
          eol = "lf";
          editor = "nvim";
          whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        };
        repack.usedeltabaseoffset = "true";
        rebase.autoSquash = "true";
        merge.stat = "true";
        branch.autosetupmerge = "true";
        credential.credentialStore = "gpg";
        init.defaultBranch = "main";
        gpg.ssh.allowedSignersFile = config.xdg.configFile."git/allowed_signers".source.outPath;
        rerere = {
          enabled = true;
          autoUpdate = true;
        };
      };
      aliases = {
        last = "log -1 HEAD";
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
        gr = ''log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'';
        lol = "log --decorate --oneline --graph --all";
        lof = "log --oneline --decorate --all --graph --first-parent";
        loa = "log --decorate --oneline --graph";
        lob = "log --decorate --oneline --graph --first-parent";
        lolb = ''log --graph --pretty=format:"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'';
        lola = "lolb --all";
        lold = ''log --graph --pretty=format:"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'';
        loldr = "lold --date=short";

        stage = "add";
        unstage = "restore --staged";

        first-branch-commit = ''!f() { git rev-list --reverse "$(git default-branch)".."$(git branch-name)" | head -n 1; }; f'';
        default-branch = ''!basename -- "$(git symbolic-ref refs/remotes/origin/HEAD --short)"'';

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
        recreate = ''!f() { [[ -n $@ ]] && git checkout "$@" && git unpublish && git checkout master && git branch -D "$@" && git checkout -b "$@" && git publish; }; f'';
        "rec" = "!git recreate";

        # Fire up your difftool (e.g. Kaleidescope) with all the changes that
        # are on the current branch.
        code-review = "difftool origin/master...";
        cr = "!git code-review";

        # Given a merge commit, find the span of commits that exist(ed) on that
        # branch. Again, not so useful in itself, but used by other aliases.
        merge-span = "!f() { echo $(git log -1 $2 --merges --pretty=format:%P | cut -d' ' -f1)$1$(git log -1 $2 --merges --pretty=format:%P | cut -d' ' -f2); }; f";

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
        dft = "difftool";
        dlog = "!f() { GIT_EXTERNAL_DIFF=diff-so-fancy git log -p --ext-diff $@; }; f";

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
        delete-merged-branches = "!git checkout master && git branch --merged | grep -v '\\\\*' | xargs -n 1 git branch -d";

        rm-merged = ''!echo "Deprecated. Use 'git gone' instead."; git gone'';
        gone = ''!git branch --format '%(refname:short) %(upstream:track)' | awk '$2 == "[gone]" { print $1 }' | xargs -r git branch -D'';

        # Checkout a merge request locally
        mr = "!sh -c 'git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2' -";

        # Hide nix flakes from git history while allowing nix to execute the flake as normal
        hide-flake = "!git add --intent-to-add flake.nix flake.lock && git update-index --assume-unchanged flake.nix flake.lock";
      };
    };

    gipphe.windows.home.file = {
      ".config/git/config".text = lib.generators.toGitINI (
        let
          base = builtins.removeAttrs config.programs.git.iniContent [
            "credential"
            "diff-so-fancy"
            "gpg"
            "interactive"
            "diff"
          ];
        in
        base
        // {
          commit = base.commit // {
            gpgSign = false;
          };
          tag = base.tag // {
            gpgSign = false;
          };
          core = base.core // {
            pager = "less '--tabs=4' -RFX";
          };
        }
      );
      ".config/git/ignore".source = config.xdg.configFile."git/ignore".source;
    };
  };
}
