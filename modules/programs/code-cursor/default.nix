{
  config,
  util,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.gipphe.programs.code-cursor;
in
util.mkProgram {
  name = "code-cursor";
  options.gipphe.programs.code-cursor = {
    wsl = lib.mkEnableOption "WSL integration";
    configFile = lib.mkOption {
      description = "Configuration file";
      type = lib.types.path;
      default = ./config.json;
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

      (lib.mkIf (!cfg.wsl) {
        home = {
          file."Library/Application Support/Cursor/User/settings.json".source = lib.mkIf pkgs.stdenv.isDarwin cfg.configFile;
          packages = lib.mkIf pkgs.stdenv.isLinux [
            (pkgs.writeShellScriptBin "cursor" ''
              ${pkgs.code-cursor}/bin/cursor "$@" &>/dev/null &
            '')
          ];
        };
      })

      (lib.mkIf pkgs.stdenv.isLinux {
        xdg.configFile."Cursor/User/settings.json".source = cfg.configFile;
      })

      {
        gipphe.windows.home.file."AppData/Roaming/Cursor/User/settings.json".source =
          config.gipphe.programs.code-cursor.configFile;
      }
    ]
  );
  system-darwin.homebrew.casks = lib.mkIf (!cfg.wsl) [ "cursor" ];
}
