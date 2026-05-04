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
          hyprctl dispatch 'hl.dsp.close()'
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
            sleep 1 && hyprctl dispatch dpms on eDP-1
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

  dispatch = import ./options/dispatchers.nix { inherit lib; };
  mod = "SUPER";
in
util.mkModule {
  hm = {
    gipphe.programs.hyprland.settings = {
      binds =
        workspaceSwitching
        ++ (map binds.toHyprBindConfig config.gipphe.core.wm.binds)
        ++ [
          {
            key = "${mod} + Q";
            dispatcher = dispatch.exec_cmd "${killactive}"; # Close current window
          }
          {
            key = "${mod} + SHIFT + Q";
            dispatcher = dispatch.window.kill null; # Force close current window
          }
          {
            key = "${mod} + T";
            dispatcher = dispatch.window.float { }; # Toggle between tiling and floating window
          }
          {
            key = "${mod} + F";
            dispatcher = dispatch.window.fullscreen { }; # Open the window in fullscreen
          }
          {
            key = "${mod} + P";
            dispatcher = dispatch.window.pseudo { }; # dwindle
          }
          {
            key = "${mod} + J";
            dispatcher = dispatch.layout "togglesplit"; # dwindle
          }
          {
            key = "${mod} + F1";
            dispatcher = dispatch.exec_cmd "${gamemode}";
          }

          # Move focus with mod + arrow keys
          {
            key = "${mod} + left";
            dispatcher = dispatch.focus { direction = "l"; };
          }
          {
            key = "${mod} + right";
            dispatcher = dispatch.focus { direction = "r"; };
          }
          {
            key = "${mod} + up";
            dispatcher = dispatch.focus { direction = "u"; };
          }
          {
            key = "${mod} + down";
            dispatcher = dispatch.focus { direction = "d"; };
          }

          # Scroll through existing workspaces with mod + scroll
          {
            key = "${mod} + mouse_down";
            dispatcher = dispatch.focus { workspace = "e+1"; };
          }
          {
            key = "${mod} + mouse_up";
            dispatcher = dispatch.focus { workspace = "e-1"; };
          }

          {
            key = "switch:off:Lid Switch";
            dispatcher = dispatch.exec_cmd "${lid-switch} open";
            locked = true;
          }
          {
            key = "switch:on:Lid Switch";
            dispatcher = dispatch.exec_cmd "${lid-switch} close";
            locked = true;
          }

          # Move/resize windows with mod + LMB/RMB and dragging
          {
            key = "${mod} + mouse:272";
            dispatcher = dispatch.window.drag;
            mouse = true;
          }
          {
            key = "${mod} + mouse:273";
            dispatcher = dispatch.window.resize;
            mouse = true;
          }

          # Zoom
          {
            key = "${mod} + mouse_down";
            dispatcher = dispatch.exec_cmd "${increase-zoom}";
          }
          {
            key = "${mod} + mouse_up";
            dispatcher = dispatch.exec_cmd "${decrease-zoom}";
          }
          {
            key = "${mod} + SHIFT + mouse_up";
            dispatcher = dispatch.exec_cmd "${reset-zoom}";
          }
          {
            key = "${mod} + SHIFT + mouse_down";
            dispatcher = dispatch.exec_cmd "${reset-zoom}";
          }
          {
            key = "${mod} + SHIFT + minus";
            dispatcher = dispatch.exec_cmd "${reset-zoom}";
          }
          {
            key = "${mod} + SHIFT + KP_SUBTRACT";
            dispatcher = dispatch.exec_cmd "${reset-zoom}";
          }
          {
            key = "${mod} + SHIFT + 0";
            dispatcher = dispatch.exec_cmd "${reset-zoom}";
          }

          {
            key = "${mod} + equal";
            dispatcher = dispatch.exec_cmd "${increase-zoom}";
            repeating = true;
          }
          {
            key = "${mod} + minus";
            dispatcher = dispatch.exec_cmd "${decrease-zoom}";
            repeating = true;
          }
          {
            key = "${mod} + KP_ADD";
            dispatcher = dispatch.exec_cmd "${increase-zoom}";
            repeating = true;
          }
          {
            key = "${mod} + KP_SUBTRACT";
            dispatcher = dispatch.exec_cmd "${decrease-zoom}";
            repeating = true;
          }

          # Locked mode
          {
            key = "${mod} + ALT_L + H";
            dispatcher = dispatch.submap "locked";
          }
        ];
      submaps = {
        reset.binds = [
          {
            key = "${mod} + ALT_L + H";
            dispatcher = dispatch.submap "reset";
          }
        ];
      };
    };
  };
}
