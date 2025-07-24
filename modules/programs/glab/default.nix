{
  util,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.glab;
in
util.mkProgram {
  name = "glab";
  options.gipphe.programs.glab = {
    aliases = lib.mkOption {
      type = with lib.types; attrsOf str;
      description = "Aliases that allow you to create nicknames for glab commands.";
      example = {
        co = "mr checkout";
        ci = "pipeline ci";
      };
      default = { };
    };
    settings = {
      git_protocol = lib.mkOption {
        type = lib.types.enum [
          "ssh"
          "https"
        ];
        description = "What protocol to use when performing Git operations.";
        example = "https";
        default = "ssh";
      };
      editor = lib.mkOption {
        type = with lib.types; nullOr str;
        description = "What editor glab should run when creating issues, merge requests, etc. This global config cannot be overriden by hostname.";
        example = "vim";
        default = null;
      };
      browser = lib.mkOption {
        type = with lib.types; nullOr str;
        description = "What browser glab should runw hen opening links.";
        example = "firefox";
        default = null;
      };
      glamour_style = lib.mkOption {
        type = lib.types.enum [
          "dark"
          "light"
          "notty"
        ];
        description = "Set your desired Markdown renderer style";
        example = "notty";
        default = "dark";
      };
      display_hyperlinks = lib.mkOption {
        type = lib.types.bool;
        description = "Whether or not to display hyperlink escape characters when listing items like issues or merge requests. Set to TRUE to display hyperlinks in TTYs only. Force hyperlinks to setting FORCE_HYPERLINKS=1 as an environment variable.";
        example = true;
        default = false;
      };
      host = lib.mkOption {
        type = lib.types.str;
        description = "Default GitLab hostname to use.";
        default = "gitlab.com";
        example = "git.example.com";
      };
      no_prompt = lib.mkOption {
        type = lib.types.bool;
        description = "Enable or disable prompts";
        default = false;
        example = true;
      };
      telemetry = lib.mkOption {
        type = lib.types.bool;
        description = ''
          Set to false to disable sending usage data to your GitLab instance or true to enable.
          See https://docs.gitlab.com/administration/settings/usage_statistics/
          for more information.
        '';
        default = true;
        example = false;
      };
      hosts = lib.mkOption {
        description = "Configuration specific for GitLab instances. API tokens should be passed from the environment, due to lack of support for separated configurations and secrets in glab. See https://gitlab.com/gitlab-org/cli/-/tree/main#gitlab-access-variables";
        default = { };
        type =
          with lib.types;
          attrsOf (submodule {
            options = {
              api_protocol = lib.mkOption {
                type = lib.types.enum [
                  "http"
                  "https"
                ];
                description = "What protocol to use to access the API endpoint.";
                default = "https";
                example = "http";
              };
              api_host = lib.mkOption {
                type = with lib.types; nullOr str;
                description = "Configure host for API endpoint. Defaults to host itself";
                default = null;
                example = "git.example.com";
              };
              git_protocol = lib.mkOption {
                type = lib.types.enum [
                  "ssh"
                  "https"
                ];
                description = "What protocol to use for Git operations.";
                default = "https";
                example = "ssh";
              };
              user = lib.mkOption {
                type = lib.types.str;
                description = "Your username in the GitLab instance.";
                example = "john.doe";
              };
            };
          });
      };
    };
  };
  hm =
    let
      finalSettings = cfg.settings // {
        check_update = false;
        last_update_check_timestamp = "1970-01-01T01:00:00Z";
        hosts = lib.mapAttrs (
          host: xs:
          xs
          // {
            token = null;
            api_host = xs.api_host or host;
          }
        ) cfg.settings.hosts;
      };

      # settings = pkgs.writeText "glab-settings" (builtins.toJSON finalSettings);
      # aliases = pkgs.writeText "glab-aliases" (builtins.toJSON cfg.aliases);
      # configFiles = pkgs.linkFarm "glab-config" {
      #   "config.yaml" = settings;
      #   "aliases.yaml" = aliases;
      # };
      inherit (pkgs) glab;
      # glab = pkgs.symlinkJoin {
      #   name = "glab";
      #   paths = [ pkgs.glab ];
      #   buildInputs = [ pkgs.makeWrapper ];
      #   postBuild = ''
      #     wrapProgram $out/bin/glab --set GLAB_CONFIG_DIR="${configFiles}"
      #   '';
      # };
    in
    {
      sops.secrets.lovdata-gitlab-ci-access-token = {
        format = "binary";
        sopsFile = ../../../secrets/utv-vnb-lt-gitlab-cli-access-token.txt;
      };
      home.packages = [
        glab
        (pkgs.writeShellScriptBin "glabl" ''
          export GITLAB_TOKEN="$(cat '${config.sops.secrets.lovdata-gitlab-ci-access-token.path}')"
          export GITLAB_HOST="https://git.lovdata.no"
          export GITLAB_GROUP="ld"
          ${glab}/bin/glab "$@"
        '')
      ];
      xdg.configFile = {
        "glab-cli/aliases.yml".text = builtins.toJSON cfg.aliases;
        "glab-cli/config.yml".text = builtins.toJSON finalSettings;
      };
    };
}
