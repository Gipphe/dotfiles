{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./tide.nix
    ./starship
  ];

  config = lib.mkIf config.gipphe.programs.fish.enable {
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
        shellInit = lib.mkBefore ''
          set fish_greeting ""
          set -gx SSH_ENV "$HOME/.ssh/agent-environment"

          init_ssh_agent
          add_ssh_keys_to_agent

          # Must be declared in shellInit because shellAbbrs does not escape "?"
          abbr --add -- '?' 'mods --role shell -q'
        '';
        package = pkgs.fish;
        shellAbbrs = {
          k = "kubectl";
          kn = "kubens";
          kcx = "kubectx";
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
          "rm -rf" = "rm -rfi";
          "rm -fr" = "rm -fri";
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
  };
}
