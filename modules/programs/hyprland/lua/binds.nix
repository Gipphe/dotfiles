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
    util.writeFishApplication {
      name = "lid-switch";
      runtimeInputs = [ config.wayland.windowManager.hyprland.package ];
      text = /* fish */ ''
        set -l monitors "$(hyprctl monitors all -j | jq 'length')"
        if test $monitors == 1
          if test $argv[1] == "close"
            systemctl suspend
          else
            sleep 1 && hyprctl dispatch 'hl.dsp.dpms { action = "on", monitor = "eDP-1" }'
          end
        end
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
            key = "${mod} + ${ws}";
            dispatcher = dispatch.focus { workspace = ws; };
          }
          {
            key = "${mod} + SHIFT + ${ws}";
            dispatcher = dispatch.window.move { workspace = ws; };
          }
        ]
      ) 9
    );

  dispatch = import ./dispatchers.nix { inherit lib; };
  mod = "SUPER";
in
util.mkModule {
  home-manager = {
    wayland.windowManager.hyprland.settings = {
      binds =
        workspaceSwitching
        ++ (map binds.toHyprBindConfig config.gipphe.core.wm.binds)
        ++ [
          {
            _args = [
              "${mod} + Q"
              (dispatch.exec_cmd "${killactive}") # Close current window
            ];
          }
          {
            _args = [
              "${mod} + SHIFT + Q"
              (dispatch.window.kill null) # Force close current window
            ];
          }
          {
            _args = [
              "${mod} + T"
              (dispatch.window.float { }) # Toggle between tiling and floating window
            ];
          }
          {
            _args = [
              "${mod} + F"
              (dispatch.window.fullscreen { }) # Open the window in fullscreen
            ];
          }
          {
            _args = [
              "${mod} + P"
              (dispatch.window.pseudo { }) # dwindle
            ];
          }
          {
            _args = [
              "${mod} + J"
              (dispatch.layout "togglesplit") # dwindle
            ];
          }
          {
            _args = [
              "${mod} + F1"
              (dispatch.exec_cmd "${gamemode}")
            ];
          }

          # Move focus with mod + arrow keys
          {
            _args = [
              "${mod} + left"
              (dispatch.focus { direction = "l"; })
            ];
          }
          {
            _args = [
              "${mod} + right"
              (dispatch.focus { direction = "r"; })
            ];
          }
          {
            _args = [
              "${mod} + up"
              (dispatch.focus { direction = "u"; })
            ];
          }
          {
            _args = [
              "${mod} + down"
              (dispatch.focus { direction = "d"; })
            ];
          }

          # Scroll through existing workspaces with mod + scroll
          {
            _args = [
              "${mod} + mouse_down"
              (dispatch.focus { workspace = "e+1"; })
            ];
          }
          {
            _args = [
              "${mod} + mouse_up"
              (dispatch.focus { workspace = "e-1"; })
            ];
          }

          {
            _args = [
              "switch:off:Lid Switch"
              (dispatch.exec_cmd "${lid-switch} open")
              { locked = true; }
            ];
          }
          {
            _args = [
              "switch:on:Lid Switch"
              (dispatch.exec_cmd "${lid-switch} close")
              { locked = true; }
            ];
          }

          # Move/resize windows with mod + LMB/RMB and dragging
          {
            _args = [
              "${mod} + mouse:272"
              (dispatch.window.drag)
              { mouse = true; }
            ];
          }
          {
            _args = [
              "${mod} + mouse:273"
              (dispatch.window.resize)
              { mouse = true; }
            ];
          }

          # Zoom
          {
            _args = [
              "${mod} + mouse_down"
              (dispatch.exec_cmd "${increase-zoom}")
            ];
          }
          {
            _args = [
              "${mod} + mouse_up"
              (dispatch.exec_cmd "${decrease-zoom}")
            ];
          }
          {
            _args = [
              "${mod} + SHIFT + mouse_up"
              (dispatch.exec_cmd "${reset-zoom}")
            ];
          }
          {
            _args = [
              "${mod} + SHIFT + mouse_down"
              (dispatch.exec_cmd "${reset-zoom}")
            ];
          }
          {
            _args = [
              "${mod} + SHIFT + minus"
              (dispatch.exec_cmd "${reset-zoom}")
            ];
          }
          {
            _args = [
              "${mod} + SHIFT + KP_SUBTRACT"
              (dispatch.exec_cmd "${reset-zoom}")
            ];
          }
          {
            _args = [
              "${mod} + SHIFT + 0"
              (dispatch.exec_cmd "${reset-zoom}")
            ];
          }

          {
            _args = [
              "${mod} + equal"
              (dispatch.exec_cmd "${increase-zoom}")
              { repeating = true; }
            ];
          }
          {
            _args = [
              "${mod} + minus"
              (dispatch.exec_cmd "${decrease-zoom}")
              { repeating = true; }
            ];
          }
          {
            _args = [
              "${mod} + KP_ADD"
              (dispatch.exec_cmd "${increase-zoom}")
              { repeating = true; }
            ];
          }
          {
            _args = [
              "${mod} + KP_SUBTRACT"
              (dispatch.exec_cmd "${decrease-zoom}")
              { repeating = true; }
            ];
          }

          # Locked mode
          {
            _args = [
              "${mod} + ALT_L + H"
              (dispatch.submap "locked")
            ];
          }
        ];
      submaps = {
        locked.settings.binds = [
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
