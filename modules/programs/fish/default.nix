{
  inputs,
  lib,
  pkgs,
  util,
  config,
  ...
}:
util.mkProgram {
  name = "fish";
  options.gipphe.programs.fish = {
    prompt = lib.mkOption {
      description = "Which prompt to use";
      type = lib.types.enum [
        "tide"
        "starship"
      ];
      default = "starship";
      example = "tide";
    };
  };
  homeManager = {
    imports = [
      ./starship
      (inputs.wlib.lib.getInstallModule {
        name = "fish";
        value = ./wrapper;
      })
    ];

    options.gipphe.programs.fish.package = lib.mkPackageOption pkgs "fish" { } // {
      default = config.wrappers.fish.wrapper;
    };

    config = {
      programs.man.generateCaches = true;
      home.packages = [ pkgs.procps ];

      wrappers.fish = {
        enable = true;

        sessionVariablesFile = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

        init = {
          shell = lib.mkBefore /* fish */ ''
            set fish_greeting ""

            # Work around for the "5u" problem with fish >=4. Remove and
            # reset this variable once fish 4.1 is out.
            #
            # See:
            # https://github.com/fish-shell/fish-shell/issues/10994
            # https://www.reddit.com/r/termux/comments/1j6z371/fish_shell_prompt_issue/
            # https://github.com/Swordfish90/cool-retro-term/issues/873
            set -U fish_features no-keyboard-protocols
          '';

          interactiveShell = lib.mkAfter /* fish */ ''
            set -U fish_color_param 80869f
            set -U fish_color_autosuggestion 5b6078
            set fish_complete_path $fish_complete_path ${config.xdg.cacheHome}/fish/completions
          '';
          shellAbbrs = {
            tf = "terraform";
            rm = "rm -i";
          };
        };
        plugins = [
          {
            name = "bass";
            inherit (pkgs.fishPlugins.bass) src;
          }
          {
            name = "nix";
            src = pkgs.fetchFromGitHub {
              owner = "kidonng";
              repo = "nix.fish";
              rev = "master";
              sha256 = "sha256-GMV0GyORJ8Tt2S9wTCo2lkkLtetYv0rc19aA5KJbo48=";
            };
          }
        ];
      };

      programs = {
        bash = {
          enable = true;
          initExtra = ''
            if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]; then
              shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
              exec ${config.wrappers.fish.wrapper}/bin/fish $LOGIN_OPTION
            fi
          '';
        };
      };

      home.activation.generateFishCompletions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        _completionsDir="${config.xdg.cacheHome}/fish/completions"
        mkdir -p "$_completionsDir"
        find "$_completionsDir" -name "*.fish" -delete 2>/dev/null || true
        for _pkg in ${lib.escapeShellArgs (map toString (lib.filter lib.isDerivation config.home.packages))}; do
          if [[ -d "$_pkg/share/man" ]]; then
            find -L "$_pkg/share/man" -type f \
              -exec ${pkgs.python3}/bin/python3 \
                ${config.wrappers.fish.package}/share/fish/tools/create_manpage_completions.py \
                --directory "$_completionsDir" {} + \
              > /dev/null 2>&1 || true
          fi
        done
      '';

      # xdg.configFile =
      #   let
      #     inherit (builtins) readDir attrNames foldl';
      #     inherit (lib.attrsets) filterAttrs;
      #     functions = lib.pipe ./functions [
      #       readDir
      #       (filterAttrs (_: t: t == "regular"))
      #       attrNames
      #       (foldl' (
      #         fs: fname:
      #         fs
      #         // {
      #           "fish/functions/${fname}" = {
      #             source = ./functions/${fname};
      #           };
      #         }
      #       ) { })
      #     ];
      #   in
      #   functions;
    };
  };
}
