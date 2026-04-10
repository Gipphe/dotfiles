{
  inputs,
  lib,
  config,
  util,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.wezterm;
  hmCfg = config.programs.wezterm;
in
util.mkProgram {
  name = "wezterm";
  options.gipphe.programs.wezterm = {
    default = lib.mkEnableOption "default terminal" // {
      default = true;
    };
    settings = lib.mkOption {
      type = with lib.types; attrsOf anything;
      description = "Extra options to set.";
      default = { };
    };
  };
  hm = {
    imports = [
      (inputs.wlib.lib.mkInstallModule {
        loc = [
          "home"
          "packages"
        ];
        name = "wezterm";
        value = inputs.wlib.lib.wrapperModules.wezterm;
      })
    ];
    config = lib.mkMerge [
      {
        wrappers.wezterm = {
          enable = true;
          "wezterm.lua".content = /* lua */ ''
            local wezterm = require("wezterm")
            local stylix_config = require("stylix")
            local user_config = require("config")

            local config = wezterm.config_builder and wezterm.config_builder() or {}
            for k, v in pairs(stylix_config)
              config[k] = v
            end
            for k, v in pairs(user_config)
              config[k] = v
            end

            return config
          '';
          constructFiles = {
            config = {
              relPath = "config.lua";
              content = builtins.readFile ./wezterm.lua;
            };
            stylix = {
              relPath = "stylix.lua";
              content = /* lua */ ''
                return {
                  ${config.stylix.targets.wezterm.luaBody}
                }
              '';
            };
          };
        };

        gipphe.core.wm.binds = [
          {
            mod = "Mod";
            key = "Return";
            action.spawn = "${hmCfg.package}/bin/wezterm";
          }
        ];
      }

      (lib.mkIf cfg.default {
        home.sessionVariables.TERMINAL = "${hmCfg.package}/bin/wezterm";

        home.packages = [
          (pkgs.writeShellScriptBin "x-terminal-emulator" ''
            ${hmCfg.package}/bin/wezterm start "$@"
          '')
        ];

        xdg.terminal-exec.settings.default = [ "wezterm.desktop" ];
      })
    ];
  };
}
