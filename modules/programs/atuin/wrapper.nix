{
  config,
  lib,
  pkgs,
  wlib,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };

  # atuin 18.13.0 deprecated `atuin daemon` in favour of `atuin daemon start`
  daemonArgs =
    if lib.versionAtLeast config.package.version "18.13.0" then
      [
        "daemon"
        "start"
      ]
    else
      [ "daemon" ];

  tomlBuilder = ''mkdir -p "$(dirname -- "$2")" && ${pkgs.remarshal}/bin/json2toml "$1" "$2"'';
in
{
  imports = [ wlib.modules.default ];
  options = {
    stateDir = lib.mkOption {
      type = lib.types.str;
      description = "Directory to use as state directory.";
      example = lib.literalExpression ''"''${config.xdg.stateHome}/atuin'';
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      description = "Directory to use as data directory.";
      example = lib.literalExpression ''"''${config.xdg.dataHome}/atuin'';
    };

    logDir = lib.mkOption {
      type = lib.types.str;
      description = "Directory to use for log files.";
      example = lib.literalExpression ''"''${config.xdg.dataHome}/atuin/logs'';
    };

    initFlags = lib.mkOption {
      default = [ ];
      type = lib.types.listOf lib.types.str;
      example = [
        "--disable-up-arrow"
        "--disable-ctrl-r"
      ];
      description = ''
        Flags to append to the shell hook.
      '';
    };

    settings = lib.mkOption {
      type =
        with lib.types;
        let
          prim = oneOf [
            bool
            int
            str
          ];
          primOrPrimAttrs = either prim (attrsOf prim);
          entry = either prim (listOf primOrPrimAttrs);
          entryOrAttrsOf = t: either entry (attrsOf t);
          entries = entryOrAttrsOf (entryOrAttrsOf entry);
        in
        attrsOf entries // { description = "Atuin configuration"; };
      default = { };
      example = lib.literalExpression ''
        {
          auto_sync = true;
          sync_frequency = "5m";
          sync_address = "https://api.atuin.sh";
          search_mode = "prefix";
        }
      '';
      description = ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/atuin/config.toml`.

        See <https://docs.atuin.sh/configuration/config/> for the full list
        of options.
      '';
    };

    forceOverwriteSettings = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        When enabled, force overwriting of the Atuin configuration file
        ({file}`$XDG_CONFIG_HOME/atuin/config.toml`).
        Any existing Atuin configuration will be lost.

        Enabling this is useful when adding settings for the first time
        because Atuin writes its default config file after every single
        shell command, which can make it difficult to manually remove.
      '';
    };

    themes = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          tomlFormat.type
          lib.types.path
          lib.types.lines
        ]
      );
      description = ''
        Each theme is written to
        {file}`$XDG_CONFIG_HOME/atuin/themes/theme-name.toml`
        where the name of each attribute is the theme-name

        See <https://docs.atuin.sh/guide/theming/> for the full list
        of options.
      '';
      default = { };
      example = lib.literalExpression ''
        {
          "my-theme" = {
            theme.name = "My Theme";
            colors = {
              Base = "#000000";
              Title = "#FFFFFF";
            };
          };
        }
      '';
    };

    daemon = {
      enable = lib.mkEnableOption "Atuin daemon";

      systemd.enable = lib.mkEnableOption "systemd units for daemon";

      logLevel = lib.mkOption {
        default = null;
        type = lib.types.nullOr (
          lib.types.enum [
            "trace"
            "debug"
            "info"
            "warn"
            "error"
          ]
        );
        description = ''
          Verbosity of Atuin daemon logging.
        '';
      };
    };
  };

  config =
    let
      flagsStr = lib.escapeShellArgs config.initFlags;
    in
    lib.mkMerge [
      {
        package = lib.mkDefault pkgs.atuin;
        env.ATUIN_CONFIG_DIR = "${placeholder "out"}/config";
        constructFiles = {
          config = {
            relPath = "config/config.toml";
            content = builtins.toJSON config.settings;
            builder = tomlBuilder;
          };
        }
        // lib.mapAttrs' (name: theme: {
          name = "theme-${name}";
          value = {
            relPath = "config/themes/${name}.toml";
            content = builtins.toJSON theme;
            builder = tomlBuilder;
          }
          // (
            if lib.isString theme then
              {
                content = theme;
              }
            else if builtins.isPath theme || lib.isStorePath theme then
              {
                content = theme;
                builder = ''mkdir -p "$(dirname -- "$2")" && ln -s "$1" "$2"'';
              }
            else
              {
                content = builtins.toJSON theme;
                builder = tomlBuilder;
              }
          );
        }) config.themes;

        settings = {
          logs.dir = lib.mkDefault config.logDir;
          db_path = lib.mkDefault "${config.dataDir}/history.db";
          key_path = lib.mkDefault "${config.dataDir}/key";
          session_path = lib.mkDefault "${config.dataDir}/session";
        };

        passthru.bash.initExtra = ''
          if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
            source "${pkgs.bash-preexec}/share/bash/bash-preexec.sh"
            eval "$(${config.wrapper}/bin/atuin init bash ${flagsStr})"
          fi
        '';
        passthru.zsh.initContent = ''
          if [[ $options[zle] = on ]]; then
            eval "$(${config.wrapper}/bin/atuin init zsh ${flagsStr})"
          fi
        '';
        passthru.fish.interactiveShellInit = ''
          ${config.wrapper}/bin/atuin init fish ${flagsStr} | source
        '';
        passthru.nushell.extraConfig = ''
          source ${
            pkgs.runCommand "atuin-nushell-config.nu"
              {
                nativeBuildInputs = [ pkgs.writableTmpDirAsHomeHook ];
              }
              ''
                ${config.wrapper}/bin/atuin init nu ${flagsStr} >> "$out"
              ''
          }
        '';
      }

      (lib.mkIf config.daemon.enable {
        settings.daemon = {
          enabled = true;
          systemd_socket = config.daemon.systemd.enable;
          socket_path = lib.mkDefault "${config.dataDir}/daemon.sock";
          pidfile_path = lib.mkDefault "${config.dataDir}/atuin-daemon.pid";
        };

        passthru.home-manager.systemd.user.services.atuin-daemon = {
          Unit = {
            Description = "Atuin daemon";
            Requires = [ "atuin-daemon.socket" ];
          };
          Install = {
            Also = [ "atuin-daemon.socket" ];
            WantedBy = [ "default.target" ];
          };
          Service = {
            ExecStart = "${config.wrapper}/bin/atuin ${lib.concatStringsSep " " daemonArgs}";
            Environment = lib.optionals (config.daemon.logLevel != null) [
              "ATUIN_LOG=${config.daemon.logLevel}"
            ];
            Restart = "on-failure";
            RestartSteps = 3;
            RestartMaxDelaySec = 6;
          };
        };

        passthru.home-manager.systemd.user.sockets.atuin-daemon =
          let
            socket_dir = if lib.versionAtLeast config.package.version "18.4.0" then "%t" else "%D/atuin";
          in
          {
            Unit = {
              Description = "Atuin daemon socket";
            };
            Install = {
              WantedBy = [ "sockets.target" ];
            };
            Socket = {
              ListenStream = "${socket_dir}/atuin.sock";
              SocketMode = "0600";
              RemoveOnStop = true;
            };
          };

        passthru.home-manager.launchd.agents.atuin-daemon = {
          enable = true;
          config = {
            ProgramArguments = [ "${config.wrapper}/bin/atuin" ] ++ daemonArgs;
            EnvironmentVariables = lib.optionalAttrs (config.daemon.logLevel != null) {
              ATUIN_LOG = config.daemon.logLevel;
            };
            KeepAlive = {
              Crashed = true;
              SuccessfulExit = false;
            };
            ProcessType = "Background";
          };
        };
      })
    ];
}
