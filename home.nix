{ system, pkgs, lib, nixpkgs, ... }:
with lib;
let
  inherit (lib.attrsets) filterAttrs;
  thisMachine = readFile ./machineName
  machineConfig =
    let
      machines =
        let
          machineNames = filterAttrs (_: v: v == "directory") (readDir ./machines);
        in foldl' (l: m: l // { "${m}" = ./env/${m}/default.nix) {} machineNames;
    in machines.${thisMachine};
in {
  imports = [ ./env/common/default.nix machineConfig ];

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

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = with pkgs;
      [
        # Adds the 'hello' command to your environment. It prints a friendly
        # "Hello, world!" when run.
        # pkgs.hello

        # You can also create simple shell scripts directly inside your
        # configuration. For example, this adds a command 'my-hello' to your
        # environment:
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')

        # Essentials
        exa
        mosh
        ranger
        rclone
        ripgrep

        # Utilities
        curl
        neofetch
        pv
        watch
        tree
        hurl

        # Programming languages
        python3Full
        terraform
        nodejs_20

        # Package managers
        pipx
        yarn
        asdf-vm

        # Cryptography
        age
        magic-wormhole
        openssh
        openssl
        pwgen-secure
        rage

        # Programming tools
        lazygit
        jujutsu
        glab
        gh-dash

        # Language servers
        shellcheck
        vale

        # System and network tools
        bandwhich
        htop
        httpie
        netcat

        # Fonts
        (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
      ];

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

		git = {
			enable = true;
			userName = "Victor Nascimento Bakke";
			userEmail = "gipphe@gmail.com";
			difftastic.enable = true;
			ignores = [ ".vscode" "**/*Zone.Identifier" ];
			signing = {
				key = "23723701395B436C";
				signByDefault = true;
			};
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
			aliases = {
				last = "log -1 HEAD";
				st = "status";
				ch = "checkout";
				sw = "switch";
				fa = "fetch --all --prune";
				ba = "branch -a";
				b = "branch";
				co = "commit";
				cp = "cherry-pick";
				pp = "pull --prune";
				gr = ''log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'';
				lol = "log --decorate --oneline --graph --all";
				lof = "log --oneline --decorate --all --graph --first-parent";
				loa = "log --decorate --oneline --graph";
				lob = "log --decorate --oneline --graph --first-parent";
				lolb = "log --graph --pretty=format:\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\"";
				lola = "lolb --all";
				lold = "log --graph --pretty=format:\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset\"";
				loldr = "lold --date=short";

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
				recreate = "!f() { [[ -n $@ ]] && git checkout \"$@\" && git unpublish && git checkout master && git branch -D \"$@\" && git checkout -b \"$@\" && git publish; }; f";
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
				dft = "difftool";
				dlog = "!f() { GIT_EXTERNAL_DIFF=difft git log -p --ext-diff $@; }; f";

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

				rm-merged = "!git branch --format '%(refname:short) %(upstream:track)' | awk '$2 == \"[gone]\" { print $1 }' | xargs -r git branch -D";

        # Checkout a merge request locally
				mr = "!sh -c 'git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2' -";

        # Hide nix flakes from git history while allowing nix to execute the flake as normal
				hide-flake = "!git add --intent-to-add flake.nix flake.lock && git update-index --assume-unchanged flake.nix flake.lock";
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

		neovim = {
			enable = true;

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
