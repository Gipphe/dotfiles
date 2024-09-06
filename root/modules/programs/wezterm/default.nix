{
  lib,
  config,
  util,
  pkgs,
  ...
}:
util.mkModule {
  options.gipphe.programs.wezterm.enable = lib.mkEnableOption "wezterm";
  hm = lib.mkIf config.gipphe.programs.wezterm.enable {
    xdg.configFile = {
      "wezterm/os-utils.lua".text =
        # lua
        ''
          local M = {}

          function M.isWindows()
            return os.getenv("COMSPEC") ~= nil and os.getenv("USERPROFILE") ~= nil
          end

          return M
        '';
      "wezterm/windows-config.lua".text =
        # lua
        ''
          local wezterm = require 'wezterm'
          local OSUtils = require 'os-utils'
          local act = wezterm.action

          local M = {}

          function M.config()
            if not OSUtils.isWindows() then
              return {}
            end

            return {
              font_size = 9.0,
              initial_rows = 40,
              initial_cols = 200,
              default_prog = { 'C:\\Program Files\\PowerShell\\7\\pwsh.exe' },
              keys = {
                { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
              }
            }
          end

          return M
        '';
    };
    programs.wezterm = {
      enable = true;
      extraConfig = # lua
        ''
          local windowsConfig = require 'windows-config'
          local baseConfig = {
            hide_tab_bar_if_only_one_tab = true,
            send_composed_key_when_left_alt_is_pressed = true,
            send_composed_key_when_right_alt_is_pressed = false,
            default_cursor_style = 'BlinkingBar',
            -- Disable easing for cursor, blinking text and visual bell
            animation_fps = 1,
          }
          for k,v in pairs(windowsConfig.config()) do
            baseConfig[k] = v
          end
          return baseConfig
        '';
    };

    home.activation."copy-wezterm-config-to-repo" = lib.hm.dag.entryAfter [ "onFilesChange" ] (
      let
        inherit (util) copyFileFixingPaths mkCopyActivationScript;
        fromDir = "${config.xdg.configHome}/wezterm";
        toDir = "${config.home.homeDirectory}/projects/dotfiles/windows/Config/wezterm";
        fix-wezterm-config-paths =
          copyFileFixingPaths "fix-wezterm-config-paths" "${fromDir}/wezterm.lua"
            "${toDir}/wezterm.lua";
        copy-wezterm-config-dir = mkCopyActivationScript {
          inherit fromDir toDir;
          name = "copy-wezterm-config-dir";
        };
        script = pkgs.writeShellApplication {
          name = "copy-wezterm-config";
          runtimeInputs = [
            fix-wezterm-config-paths
            copy-wezterm-config-dir
          ];
          text = ''
            copy-wezterm-config-dir
            fix-wezterm-config-paths
          '';
        };
      in
      "run ${script}/bin/copy-wezterm-config"
    );
  };
}
