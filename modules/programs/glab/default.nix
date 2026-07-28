{
  util,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.glab;
  finalSettings = cfg.settings // {
    check_update = false;
    last_update_check_timestamp = "1970-01-01T01:00:00Z";
    hosts = lib.mapAttrs (
      host: xs:
      lib.filterAttrs (n: _: n != "token_path") xs
      // {
        api_host = xs.api_host or host;
      }
    ) cfg.settings.hosts;
  };

  aliases = pkgs.writeText "glab-aliases" (builtins.toJSON cfg.aliases);
  settings = pkgs.writeText "glab-settings" (builtins.toJSON finalSettings);
  config-dir = "${config.gipphe.homeDirectory}/.config/gipphe/glab-cli";
  glab =
    if cfg.writeConfig then
      pkgs.symlinkJoin {
        name = "glab";
        paths = [ pkgs.glab ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/glab --set GLAB_CONFIG_DIR "${config-dir}"
        '';
      }
    else
      pkgs.glab;

  host-token-paths = lib.pipe cfg.settings.hosts [
    (lib.filterAttrs (_: x: x ? token_path && x.token_path != null && x.token_path != ""))
    (lib.mapAttrs (_: x: x.token_path))
    builtins.toJSON
    (pkgs.writeText "host-token-paths.json")
  ];
  add-tokens = util.writeNushellApplication {
    name = "add-tokens";
    runtimeEnv = {
      config_dir = config-dir;
      aliases_file = aliases.outPath;
      settings_file = settings.outPath;
      username = config.gipphe.username;
      host_token_paths_file = host-token-paths.outPath;
    };
    text = /* nu */ ''
      def main[] {
        mkdir $env.config_dir
        chmod -R 755 $env.config_dir
        cp -f $env.aliases_file $"($env.config_dir)/aliases.yml"
        cp -f $env.settings_file $"($env.config_dir)/config.yml"
        chown -R $"($env.username):($env.username)" $env.config_dir
        chmod -R 600 $env.config_dir/*

        let hosts = (open -r $env.host_token_paths_file | from json)
        if ($hosts | length) == 0 {
          exit 0
        }

        let host_tokens = {
          hosts: (
            $hosts
              | items { |host, path| 
                { $host: { token: open -r $path } }
              }
              | into record
          )
        }

        let final = (open $env.config_dir/config.yml | merge $host_tokens)
        $final | save $env.config_dir/config.yml
      }
    '';
  };
in
util.mkProgram {
  name = "glab";
  options.gipphe.programs.glab = {
    package = lib.mkPackageOption pkgs "glab" { } // {
      default = glab;
    };
    writeConfig = lib.mkEnableOption "write config file";
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
        description = "What editor glab should run when creating issues, merge requests, etc. This global config cannot be overridden by hostname.";
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
              token_path = lib.mkOption {
                type = with lib.types; nullOr str;
                description = "Path to text file containing API token to use.";
                default = null;
                example = "/home/username/secrets/glab_token.txt";
              };
            };
          });
      };
    };
  };
  homeManager.home = {
    packages = [ glab ];
    activation = lib.mkIf cfg.writeConfig {
      glab-config = lib.hm.dag.entryAfter [ "onFilesChanged" ] ''
        run ${add-tokens}/bin/add-tokens
      '';
    };
  };
}
