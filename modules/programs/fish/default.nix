{
  config,
  lib,
  pkgs,
  util,
  ...
}:
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
          enable = !pkgs.stdenv.isDarwin;
          initExtra = ''
            if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]; then
              shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
              exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
            fi
          '';
        };
        zsh = {
          enable = pkgs.stdenv.isDarwin;
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
              '';
          interactiveShellInit =
            lib.mkAfter # fish
              ''
                abbr --add "?" -- mods --role shell -q
                set -U fish_color_param 80869f
                set -U fish_color_autosuggestion 5b6078
              '';
          package = pkgs.fish;
          shellAbbrs = {
            vim = "nvim";
            tf = "terraform";
            gron = "fastgron";
            rmz = "find . -name '*Zone.Identifier' -type f -delete";
            reload_shell = "source ~/.config/fish/config.fish";
            nix-health = "nix run 'github:juspay/nix-browser#nix-health'";
            docker_clean_images = "docker rmi (docker images -a --filter=dangling=true -q)";
            docker_clean_ps = "docker rm (docker ps --filter=status=exited --filter=status=created -q)";
            docker_clean_testcontainer = ''docker rmi -f (docker images --filter="reference=*-*-*-*-*:*-*-*-*-*" --format "{{ .ID }}" | sort | uniq)'';
            docker_pull_images = "docker images --format '{{.Repository}}:{{.Tag}}' | xargs -n 1 -P 1 docker pull";
            # Taken from https://discourse.nixos.org/t/list-and-delete-nixos-generations/29637/6
            prune-gens = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/sytem --older-than";
            rm = "rm -i";
            openai-key = "cat ${config.sops.secrets.milkyway-translations-openai-key.path}";
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
          function_files = filterAttrs (_: t: t == "regular") (readDir ./functions);
          function_list = attrNames function_files;
          functions = foldl' (
            fs: fname:
            fs
            // {
              "fish/functions/${fname}" = {
                source = ./functions/${fname};
              };
            }
          ) { } function_list;
        in
        functions;

      sops.secrets."milkyway-translations-openai-key" = {
        sopsFile = ../../../secrets/strise-milkyway-translations-openai-api-key.key;
        mode = "400";
        format = "binary";
      };
    };
  };
}
