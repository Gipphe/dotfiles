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
  module = inputs.wlib.wrappers.wezterm.eval {
    inherit pkgs;
    luaInfo = {
      font_size = 10.0;
      color_scheme = "Catppuccin Macchiato";
      hide_tab_bar_if_only_one_tab = true;
      send_composed_key_when_left_alt_is_pressed = true;
      send_composed_key_when_right_alt_is_pressed = false;
      default_cursor_style = "BlinkingBar";
      # Disable easing for cursor; blinking text and visual bell
      animation_fps = 1;
      warn_about_missing_glyphs = false;
    };
    "wezterm.lua".content = /* lua */ ''
      ${formatWindowTitle}
      return require('nix-info')
    '';
  };
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
  homeManager = {
    config = lib.mkMerge [
      {
        home.packages = [ module.config.wrapper ];
        gipphe.core.wm.bind = {
          "SUPER + Return".action.spawn = "${module.config.wrapper}/bin/wezterm";
        };
      }

      (lib.mkIf cfg.default {
        home.sessionVariables.TERMINAL = "${module.config.wrapper}/bin/wezterm";

        home.packages = [
          (pkgs.writeShellScriptBin "x-terminal-emulator" ''
            ${module.config.wrapper}/bin/wezterm start "$@"
          '')
        ];

        xdg.terminal-exec.settings.default = [ "wezterm.desktop" ];
      })
    ];
  };
}
