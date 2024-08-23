{
  lib,
  config,
  pkgs,
  util,
  ...
}:
util.mkModule {
  options.gipphe.programs.git.enable = lib.mkEnableOption "git";
  hm = lib.mkIf config.gipphe.programs.git.enable {
    programs.git = {
      enable = true;
      userName = "Victor Nascimento Bakke";
      userEmail = "gipphe@gmail.com";
      diff-so-fancy.enable = true;
      ignores = [
        ".DS_Store"
        "**/*Zone.Identifier"
      ];
      signing = {
        key = "23723701395B436C";
        signByDefault = true;
      };
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
        rerere = {
          enabled = true;
          autoUpdate = true;
        };
      };
      includes = [
        {
          condition = "gitdir:**/strise/**/.git";
          contents = {
            user = {
              name = "Victor Nascimento Bakke";
              email = "victor@strise.ai";
              signingkey = "B4C7E23DDC6AE725";
            };
          };
        }
      ];
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
    home.activation.copy-git-config-for-windows = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      let
        script = pkgs.writeShellApplication {
          name = "copy-git-config";
          runtimeInputs = with pkgs; [
            gnused
            gnugrep
          ];
          runtimeEnv = {
            toDir = "${config.home.homeDirectory}/projects/dotfiles/windows/Config/git";
            fromDir = "${config.xdg.configHome}/git";
          };
          text = ''
            to_config="$toDir/config"
            to_ignore="$toDir/ignore"
            to_strise="$toDir/strise"

            from_config="$fromDir/config"
            from_ignore="$fromDir/ignore"
            from_strise=$(grep -Eo '/nix/store/.*-hm_gitconfig' "$from_config" | xargs)

            rm -rf "$toDir"
            mkdir -p "$toDir"

            cp -rL "$from_strise" "$to_strise"
            cp -rL "$from_ignore" "$to_ignore"

            sed -r 's!/nix/store/.*/(\S+)!\1!' "$from_config" \
            | sed "s!/nix/store/.*-hm_gitconfig!./.gitconfig_strise!" \
            | sed "/credentialStore/d" \
            | sed "/\[credential\]/d" \
            | sed "/external = \"diff-so-fancy/d" \
            | sed "/\[diff\]/d" \
            | sed "/diffFilter =/d" \
            | sed "/\[interactive\]/d" \
            | tee "$to_config" >/dev/null
          '';
        };
      in
      "run ${script}/bin/copy-git-config"
    );
  };
}
