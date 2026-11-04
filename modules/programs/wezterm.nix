{ inputs, ... }:
{
  den.aspects.programs.wezterm.homeManager =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      formatWindowTitle = /* lua */ ''
        do
          local wezterm = require("wezterm")
          -- Strip Zellij session name from window title
          wezterm.on("format-window-title", function(tab, _pane, _tabs, _panes, _config)
            local title = tab.active_pane.title
            -- Remove Zellij session name pattern: "session-name | actual-title"
            local stripped = title:match("^[^|]+%|%s*(.+)$")
            if stripped then
              return stripped
            end
            return title
          end)
        end
      '';
      module = inputs.wrappers.wrappers.wezterm.eval {
        inherit pkgs;
        luaInfo = lib.mkMerge [
          config.programs.wezterm.settings
          {
            font_size = lib.mkForce 10.0;
            color_scheme = lib.mkForce "Catppuccin Macchiato";
            hide_tab_bar_if_only_one_tab = true;
            send_composed_key_when_left_alt_is_pressed = true;
            send_composed_key_when_right_alt_is_pressed = false;
            default_cursor_style = "BlinkingBar";
            # Disable easing for cursor; blinking text and visual bell
            animation_fps = 1;
            warn_about_missing_glyphs = false;
          }
        ];
        "wezterm.lua".content = /* lua */ ''
          ${formatWindowTitle}
          return require('nix-info')
        '';
      };
    in
    {
      home = {
        packages = [
          module.config.wrapper
          (pkgs.writeShellScriptBin "x-terminal-emulator" ''
            ${module.config.wrapper}/bin/wezterm start "$@"
          '')
        ];
        sessionVariables.TERMINAL = "${module.config.wrapper}/bin/wezterm";
      };
      gipphe.core.wm.bind = {
        "SUPER + Return".action.spawn = "${module.config.wrapper}/bin/wezterm";
      };

      xdg.terminal-exec.settings.default = [ "wezterm.desktop" ];
    };
}
