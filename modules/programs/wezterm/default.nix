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
          luaInfo = {
            color_scheme = "Catppuccin Macchiato";
            enable_wayland = false;
            hide_tab_bar_if_only_one_tab = true;
            send_composed_key_when_left_alt_is_pressed = true;
            send_composed_key_when_right_alt_is_pressed = false;
            default_cursor_style = "BlinkingBar";
            # See https://github.com/wez/wezterm/issues/5990
            front_end = "WebGpu";
            # Disable easing for cursor; blinking text and visual bell
            animation_fps = 1;
            warn_about_missing_glyphs = false;
            # claude-code shift-enter fix
            keys = [
              {
                key = "Enter";
                mods = "SHIFT";
                action = lib.mkLuaInline ''wezterm.action({ SendString = "\\x1b\\r" })'';
              }
            ];
          };
          "wezterm.lua".content = /* lua */ ''
            ${formatWindowTitle}
            return require('nix-info')
          '';
        };

        gipphe.core.wm.binds = [
          {
            mod = "Mod";
            key = "Return";
            action.spawn = "${config.wrappers.wezterm.wrapper}/bin/wezterm";
          }
        ];
      }

      (lib.mkIf cfg.default {
        home.sessionVariables.TERMINAL = "${config.wrappers.wezterm.wrapper}/bin/wezterm";

        home.packages = [
          (pkgs.writeShellScriptBin "x-terminal-emulator" ''
            ${config.wrappers.wezterm.wrapper}/bin/wezterm start "$@"
          '')
        ];

        xdg.terminal-exec.settings.default = [ "wezterm.desktop" ];
      })
    ];
  };
}
