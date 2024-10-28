{
  config,
  util,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.gipphe.programs.code-cursor;
  settingsPackage = pkgs.writeText "code-cursor-settings.json" (builtins.toJSON cfg.settings);
in
util.mkProgram {
  name = "code-cursor";
  options.gipphe.programs.code-cursor = {
    wsl = lib.mkEnableOption "WSL integration";
    settings = lib.mkOption {
      description = "Settings for Cursor";
      type = with lib.types; attrsOf anything;
      default = { };
    };
    settingsPackage = lib.mkOption {
      description = "Package holding the settings file";
      type = lib.types.package;
      internal = true;
    };
    windowsSettings = lib.mkOption {
      description = "Windows-specific settings.";
      type = with lib.types; attrsOf anything;
      default = { };
    };
    windowsSettingsPackage = lib.mkOption {
      description = "Package holding the settings file for Windows";
      type = lib.types.package;
      internal = true;
    };
  };
  shared = {
    imports = [ ./settings.nix ];
    gipphe.programs.code-cursor = {
      inherit settingsPackage;
      windowsSettingsPackage =
        pkgs.runCommandNoCC "code-cursor-settings.windows.json"
          { settings = builtins.toJSON (cfg.settings // cfg.windowsSettings); }
          ''
            echo "$settings" \
            | ${pkgs.jq}/bin/jq '.' \
            | sed -r 's!/nix/store/.*/(\S+)!\1!' > $out
          '';
    };
  };
  hm = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.wsl {
        home = {
          # Required for VSCode/Cursor WSL extension.
          packages = [ pkgs.wget ];

          file.".vscode-server/server-env-setup".source = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/sonowz/vscode-remote-wsl-nixos/refs/heads/master/server-env-setup";
            hash = "sha256-Kd/qp4gY9WnbX4bSewytmeuyqWFwiobP7G7nxMEW8ac=";
          };
        };
      })

      (lib.mkIf pkgs.stdenv.isDarwin {
        home.file."Library/Application Support/Cursor/User/settings.json".source = cfg.settingsPackage;
      })

      (lib.mkIf pkgs.stdenv.isLinux {
        xdg.configFile."Cursor/User/settings.json".source = cfg.settingsPackage;
      })

      {
        gipphe.windows.home.file."AppData/Roaming/Cursor/User/settings.json".source =
          cfg.windowsSettingsPackage;
      }

      (lib.mkIf (!cfg.wsl) {
        home.packages = lib.mkIf pkgs.stdenv.isLinux [
          (pkgs.writeShellScriptBin "cursor" ''
            ${pkgs.code-cursor}/bin/cursor "$@" &>/dev/null &
          '')
        ];
      })
    ]
  );
  system-darwin.homebrew.casks = lib.mkIf (!cfg.wsl) [ "cursor" ];
}
