{
  lib,
  pkgs,
  util,
  ...
}:
let
  inherit (pkgs.stdenv) hostPlatform;
in
util.mkProgram {
  name = "fish";
  options.gipphe.programs.fish.prompt = lib.mkOption {
    description = "Which prompt to use";
    type = lib.types.enum [
      "tide"
      "starship"
    ];
    default = "starship";
    example = "tide";
  };
  hm = {
    imports = [ ./starship ];

    config = {
      home.packages = with pkgs; [ procps ];

      programs = {
        bash = {
          enable = !hostPlatform.isDarwin;
          initExtra = ''
            if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]; then
              shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
              exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
            fi
          '';
        };
        zsh = {
          enable = hostPlatform.isDarwin;
          initExtra = ''
            if [[ $(${pkgs.procps}/bin/ps -p $PPID -o comm | tail -n +2) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]; then
              LOGIN_OPTION=""
              if [[ -o login ]]; then
                LOGIN_OPTION='--login'
              fi
              exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
            fi
          '';
        };

        fish = {
          enable = true;
          shellInit =
            lib.mkBefore # fish
              ''
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
          interactiveShellInit =
            lib.mkAfter # fish
              ''
                set -U fish_color_param 80869f
                set -U fish_color_autosuggestion 5b6078
              '';
          shellAbbrs = {
            tf = "terraform";
            rm = "rm -i";
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
      };

      xdg.configFile =
        let
          inherit (builtins) readDir attrNames foldl';
          inherit (lib.attrsets) filterAttrs;
          functions = lib.pipe ./functions [
            readDir
            (filterAttrs (_: t: t == "regular"))
            attrNames
            (foldl' (
              fs: fname:
              fs
              // {
                "fish/functions/${fname}" = {
                  source = ./functions/${fname};
                };
              }
            ) { })
          ];
        in
        functions;
    };
  };
}
