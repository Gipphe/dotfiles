{
  lib,
  config,
  util,
  pkgs,
  ...
}:
util.mkProgram {
  name = "wezterm";
  hm = {
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
            -- See https://github.com/wez/wezterm/issues/5990
            front_end = "WebGpu",
            -- Disable easing for cursor, blinking text and visual bell
            animation_fps = 1,
          }
          for k,v in pairs(windowsConfig.config()) do
            baseConfig[k] = v
          end
          return baseConfig
        '';
    };

    gipphe.windows.home.file =
      config.xdg.configFile
      |> lib.filterAttrs (path: _: lib.hasPrefix "wezterm/" path)
      |> lib.mapAttrs' (
        p: v: {
          name = ".config/${p}";
          value.source = pkgs.runCommandNoCC "windows-wezterm-config-${builtins.baseNameOf p}" { } ''
            sed -r 's!/nix/store/.*/bin/(\S+)!\1!' "${v.source}" \
            | tee "$out" >/dev/null
          '';
        }
      );
  };
}
