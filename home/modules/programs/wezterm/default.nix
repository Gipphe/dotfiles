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

          function M.getOS()
            if jit then
              return jit.os
            end

            local osname
            local fh, err = assert(io.popen('uname -o 2>/dev/null', 'r'))
            if fh then
              osname = fh:read()
            end

            return osname or "Windows"
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
            local os = OSUtils.getOS()

            if os ~= 'Windows' then
              return {}
            end

            local fh, err = assert(io.popen('pwsh -Command "(Get-Command pwsh).Source"'))
            local pwsh = 'C:\\Program Files\\PowerShell\\7\\pwsh.exe'
            if fh then
              pwsh = fh:read()
            end

            return {
              default_prog = { pwsh },
              keys = {
                { key = 'V', mods = 'CTRL', action = act.PasteFrom 'ClipBoard' },
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

    home.activation."copy-wezterm-config-to-repo" =
      lib.hm.dag.entryAfter
        [
          "writeBoundary"
          "onFilesChange"
        ]
        (
          let
            inherit (util) copyFileFixingPaths mkCopyActivationScript;
            fromDir = "${config.xdg.configHome}/wezterm";
            toDir = "${config.home.homeDirectory}/projects/dotfiles/windows/Config/wezterm";
            fix-wezterm-config-paths =
              copyFileFixingPaths "fix-wezterm-config-paths" "${fromDir}/wezterm.lua"
                "${toDir}/wezterm.lua";
            copy-wezterm-config-dir = mkCopyActivationScript "copy-wezterm-config-dir" fromDir toDir;
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
