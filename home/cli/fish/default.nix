{
  pkgs,
  lib,
  config,
  ...
}:
with builtins;
with lib.attrsets;
let
  cfg = config.gipphe.fish;
in
{
  options.gipphe.fish = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
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
          set -gx tide_left_prompt_items \
            os \
            pwd \
            git \
            newline \
            character
          set -gx tide_right_prompt_items \
            status \
            cmd_duration \
            context \
            jobs \
            direnv \
            bun \
            node \
            python \
            rustc \
            java \
            php \
            pulumi \
            ruby \
            go \
            distrobox \
            toolbox \
            terraform \
            aws \
            nix_shell \
            crystal \
            elixir \
            zig \
            time

          # Disabled:
          # ...
          # go \
          #  gcloud \
          #  kubectl \
          # distrobox \
          # ...

          set -gx JAVA_HOME "${pkgs.temurin-bin}"

          init_ssh_agent
          add_ssh_keys_to_agent
        '';
        package = pkgs.fish;
        shellAbbrs = {
          set_tide_prompt = "tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Solid --prompt_connection_andor_frame_color=Dark --prompt_spacing=Sparse --icons='Many icons' --transient=Yes";
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
        };
        plugins = with pkgs; [
          {
            name = "bass";
            inherit (fishPlugins.bass) src;
          }
          {
            name = "tide";
            src = pkgs.fetchFromGitHub {
              owner = "IlanCosman";
              repo = "tide";
              rev = "57afe578d36110615df6c8ce9165d9971e271063";
              sha256 = "sha256-dw6XLjtaOF7jVAsMqH+CZJFpy20o3gc85A8CQWe/N/8=";
            };
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
        function_files = filterAttrs (f: t: t == "regular") (readDir ./functions);
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
