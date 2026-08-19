{
  pkgs,
  util,
  config,
  lib,
  ...
}:
let
  inherit (lib) genList concatLists;
  binds = import ./toHyprBinds.nix { inherit lib; };
  cfg = config.gipphe.programs.hyprland;
  niceBinds = mkNiceBinds cfg.settings.bind;
  mkNiceBinds =
    binds:
    lib.pipe binds [
      lib.attrsToList
      (map (
        { name, value }: {
          _args = [
            name
            value.action
          ]
          ++ lib.optional (value.opts != { }) value.opts;
        }
      ))
    ];
  niceSubmaps = lib.mapAttrs (_: v: {
    inherit (v) onDispatch;
    settings.bind = mkNiceBinds (v.settings.bind or { });
  }) cfg.submaps;
  wmBinds = map binds.toHyprBindConfig config.gipphe.core.wm.binds;

  killactive = lib.getExe (
    pkgs.writeShellApplication {
      name = "killactive";
      runtimeInputs = [
        config.wayland.windowManager.hyprland.package
        pkgs.xdotool
      ];
      text = /* bash */ ''
        if test "$(hyprctl activewindow -j | jq -r '.class')" = 'Steam'; then
          xdotool getactivewindow windowunmap
        else
          hyprctl dispatch 'hl.dsp.window.close()'
        fi
      '';
    }
  );

  gamemode = lib.getExe (
    pkgs.writeShellApplication {
      name = "gamemode";
      runtimeInputs = [
        config.wayland.windowManager.hyprland.package
        pkgs.jq
      ];
      text = /* bash */ ''
        ${lib.toShellVar "gamemode_config" (
          lib.generators.toLua { } {
            animations.enabled = false;
            decoration = {
              shadow.enabled = false;
              blur.enabled = false;
              fullscreen_opacity = 1.0;
              rounding = 0;
            };
            general = {
              gaps_in = 0;
              gaps_out = 0;
              border_size = 1;
            };
            input.touchpad.disable_while_typing = false;
          }
        )}

        HYPRGAMEMODE=$(hyprctl getoption animations:enabled -j | jq -r '.bool')
        if test "$HYPRGAMEMODE" = "true"; then
          hyprctl eval "hl.config($gamemode_config)"
          hyprctl eval "hl.animation { leaf = 'borderangle', enabled = 0 }"
          hyprctl notify 1 5000 "rgb(40a02b)" "Gamemode [ON]"
        else
          hyprctl reload
          hyprctl notify 1 5000 "rgb(d20f39)" "Gamemode [OFF]"
        fi
      '';
    }
  );

  lid-switch = lib.getExe (
    util.writeNushellApplication {
      name = "lid-switch";
      runtimeInputs = [ config.wayland.windowManager.hyprland.package ];
      text = /* nu */ ''
        def main [action: string] {
          let num_monitors = (hyprctl monitors all -j | from json | length)
          if $num_monitors == 1 {
            if $action == "close" {
              systemctl suspend
            } else {
              sleep 1sec
              hyprctl dispatch 'hl.dsp.dpms { action = "on", monitor = "eDP-1" }'
            }
          }
        }
      '';
    }
  );

  set-zoom-factor =
    jqFilter:
    lib.getExe (
      pkgs.writeShellApplication {
        name = "set-zoom-factor";
        runtimeInputs = [
          pkgs.jq
          config.wayland.windowManager.hyprland.package
        ];
        runtimeEnv.jq_filter = jqFilter;
        text = ''
          zoom_factor="$(hyprctl getoption cursor:zoom_factor -j | jq "$jq_filter")"
          hyprctl eval "hl.config { cursor = { zoom_factor = '$zoom_factor' } }"
        '';
      }
    );

  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
  increase-zoom = set-zoom-factor ".float * 1.1";
  decrease-zoom = set-zoom-factor "(.float * 0.9) | if . < 1 then 1 else . end";
  reset-zoom = "${hyprctl} eval 'hl.config {cursor = {zoom_factor = 1}}'";

  workspaceSwitching =
    # sioodmy's implementation
    concatLists (
      genList (
        x:
        let
          ws = toString (x + 1);
        in
        [
          {
            _args = [
              "${mod} + ${ws}"
              (dispatch.focus { workspace = ws; })
            ];
          }
          {
            _args = [
              "${mod} + SHIFT + ${ws}"
              (dispatch.window.move { workspace = ws; })
            ];
          }
        ]
      ) 9
    );

  dispatch = import ./dispatchers.nix { inherit lib; };
  bindType =
    with lib.types;
    attrsOf (submodule {
      options = {
        action = lib.mkOption {
          description = "Action to perform on keybind";
          type = either luaInline str;
        };
        opts = lib.mkOption {
          description = "Other options to pass to the key bind registration";
          default = { };
          type = attrsOf (oneOf [
            str
            int
            float
            bool
            path
          ]);
        };
      };
    });
  inherit (cfg) mod;
in
util.mkModule {
  options.gipphe.programs.hyprland = {
    mod = lib.mkOption {
      description = "Mod key";
      type = lib.types.str;
      default = "SUPER";
    };
    settings.bind = lib.mkOption {
      description = "Key bindings";
      default = { };
      type = bindType;
    };
    submaps = lib.mkOption {
      description = "Submap key bindings";
      default = { };
      type =
        with lib.types;
        attrsOf (submodule {
          options = {
            onDispatch = lib.mkOption {
              description = "Submap to use after dispatch";
              type = str;
              default = "";
            };
            settings.bind = lib.mkOption {
              description = "Binds for the submap";
              default = { };
              type = bindType;
            };
          };
        });
    };
  };
  shared = {
    imports = [ ./layouts/scrolling.nix ];
    gipphe.programs.hyprland.layouts.scrolling.enable = true;
  };
  homeManager = {
    gipphe.programs.hyprland.settings.bind = {
      # Close current window
      "${mod} + Q".action = dispatch.exec_cmd "${killactive}";
      # Force close current window
      "${mod} + SHIFT + Q".action = dispatch.window.kill null;
      "${mod} + F1".action = dispatch.exec_cmd "${gamemode}";

      # Move focus with mod + arrow keys
      "${mod} + left".action = dispatch.focus { direction = "l"; };
      "${mod} + right".action = dispatch.focus { direction = "r"; };
      "${mod} + up".action = dispatch.focus { direction = "u"; };
      "${mod} + down".action = dispatch.focus { direction = "d"; };

      "switch:off:Lid Switch" = {
        action = dispatch.exec_cmd "${lid-switch} open";
        opts.locked = true;
      };
      "switch:on:Lid Switch" = {
        action = dispatch.exec_cmd "${lid-switch} close";
        opts.locked = true;
      };

      # Move/resize windows with mod + LMB/RMB and dragging
      "${mod} + mouse:272" = {
        action = dispatch.window.drag;
        opts.mouse = true;
      };
      "${mod} + mouse:273" = {
        action = dispatch.window.resize;
        opts.mouse = true;
      };

      # Zoom
      "${mod} + mouse_down".action = dispatch.exec_cmd "${increase-zoom}";
      "${mod} + mouse_up".action = dispatch.exec_cmd "${decrease-zoom}";
      "${mod} + SHIFT + mouse_up".action = dispatch.exec_cmd "${reset-zoom}";
      "${mod} + SHIFT + mouse_down".action = dispatch.exec_cmd "${reset-zoom}";
      "${mod} + SHIFT + minus".action = dispatch.exec_cmd "${reset-zoom}";
      "${mod} + SHIFT + KP_SUBTRACT".action = dispatch.exec_cmd "${reset-zoom}";
      "${mod} + SHIFT + 0".action = dispatch.exec_cmd "${reset-zoom}";
      "${mod} + equal" = {
        action = dispatch.exec_cmd "${increase-zoom}";
        opts.repeating = true;
      };
      "${mod} + minus" = {
        action = dispatch.exec_cmd "${decrease-zoom}";
        opts.repeating = true;
      };
      "${mod} + KP_ADD" = {
        action = dispatch.exec_cmd "${increase-zoom}";
        opts.repeating = true;
      };
      "${mod} + KP_SUBTRACT" = {
        action = dispatch.exec_cmd "${decrease-zoom}";
        opts.repeating = true;
      };

      # Locked mode
      "${mod} + ALT_L + H".action = dispatch.submap "locked";
    };
    wayland.windowManager.hyprland = {
      settings.bind = workspaceSwitching ++ wmBinds ++ niceBinds;

      submaps = niceSubmaps // {
        locked.settings.bind = [
          {
            _args = [
              "${mod} + ALT_L + H"
              (dispatch.submap "reset")
            ];
          }
        ];
      };
    };
  };
}
