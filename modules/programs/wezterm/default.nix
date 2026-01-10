{
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
    xdg.configFile = {
      "wezterm/utils.lua".source = ./utils.lua;
      "wezterm/windows-config.lua".source = ./windows-config.lua;
      "wezterm/linux-config.lua".source = ./linux-config.lua;
    };
    programs.wezterm = {
      enable = true;
      extraConfig = # lua
        ''
          local wezterm = require 'wezterm'
          local utils = require 'utils'
          local windowsConfig = require 'windows-config'
          local linuxConfig = require 'linux-config'

          local baseConfig = {
            hide_tab_bar_if_only_one_tab = true,
            send_composed_key_when_left_alt_is_pressed = true,
            send_composed_key_when_right_alt_is_pressed = false,
            default_cursor_style = 'BlinkingBar',
            -- See https://github.com/wez/wezterm/issues/5990
            front_end = "WebGpu",
            -- Disable easing for cursor, blinking text and visual bell
            animation_fps = 1,
            warn_about_missing_glyphs = false,
            keys = {
              ${
                lib.optionalString config.gipphe.programs.claude-code.enable /* lua */ ''
                  {
                    key = "Enter",
                    mods = "SHIFT",
                    action = wezterm.action { SendString = "\\x1b\\r" },
                  }
                ''
              };
            },
          }

          baseConfig = utils.tbl_deep_extend(baseConfig, windowsConfig.config(), 'force')
          baseConfig = utils.tbl_deep_extend(baseConfig, linuxConfig.config(), 'force')

          -- Strip Zellij session name from window title
          wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
            local title = tab.active_pane.title
            -- Remove Zellij session name pattern: "session-name | actual-title"
            local stripped = title:match("^[^|]+%|%s*(.+)$")
            if stripped then
              return stripped
            end
            return title
          end)

          return baseConfig
        '';
    };

    home.sessionVariables = lib.mkIf cfg.default {
      TERMINAL = "${hmCfg.package}/bin/wezterm";
    };

    home.packages = lib.mkIf cfg.default [
      (pkgs.writeShellScriptBin "x-terminal-emulator" ''
        ${hmCfg.package}/bin/wezterm start "$@"
      '')
    ];

    gipphe.core.wm.binds = [
      {
        mod = "Mod";
        key = "Return";
        action.spawn = "${hmCfg.package}/bin/wezterm";
      }
    ];

    gipphe.windows.home.file = lib.pipe config.xdg.configFile [
      (lib.filterAttrs (p: _: lib.hasPrefix "wezterm/" p))
      (lib.mapAttrs' (
        p: v: {
          name = ".config/${p}";
          value.source = pkgs.runCommand "windows-wezterm-config-${baseNameOf p}" { } ''
            sed -r 's!/nix/store/.*/bin/(\S+)!\1!' "${v.source}" \
            | tee "$out" >/dev/null
          '';
        }
      ))
    ];
  };
}
