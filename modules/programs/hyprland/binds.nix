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
          hyprctl dispatch killactive ""
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
        HYPRGAMEMODE=$(hyprctl getoption animations:enabled -j | jq -r '.int')
        if test "$HYPRGAMEMODE" = 1; then
          hyprctl --batch "\
            keyword animations:enabled 0; \
            keyword animation borderangle,0; \
            keyword decoration:shadow:enabled 0; \
            keyword decoration:blur:enabled 0; \
            keyword decoration:fullscreen_opacity 1; \
            keyword general:gaps_in 0; \
            keyword general:gaps_out 0; \
            keyword general:border_size 1; \
            keyword decoration:rounding 0; \
            keyword input:touchpad:disable_while_typing false \
          "
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
in
util.mkModule {
  hm = {
    wayland.windowManager.hyprland.settings = lib.mkMerge [
      {
        bind = [
          "$mod, Q, exec, ${killactive}" # Close current window
          "$mod SHIFT, Q, forcekillactive" # Force close current window
          "$mod, T, togglefloating # Toggle between tiling and floating window"
          "$mod, F, fullscreen # Open the window in fullscreen"
          "$mod, P, pseudo, # dwindle"
          "$mod, J, layoutmsg, togglesplit, # dwindle"

          "$mod, F1, exec, ${gamemode}"

          # Move focus with mod + arrow keys
          "$mod, left, movefocus, l # Move focus left"
          "$mod, right, movefocus, r # Move focus right"
          "$mod, up, movefocus, u # Move focus up"
          "$mod, down, movefocus, d # Move focus down"

          # Scroll through existing workspaces with mod + scroll
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"

          # Cycle to next window with Alt + Tab
          "Alt_L, Tab, cyclenext,"
          "Alt_L, Tab, bringactivetotop,"
          "Alt_L Shift, Tab, cyclenext, prev"
          "Alt_L Shift, Tab, bringactivetotop,"
        ];

        bindl = [
          ", switch:off:Lid Switch, exec, ${lid-switch} open"
          ", switch:on:Lid Switch, exec, ${lid-switch} close"
        ];

        bindm = [
          # Move/resize windows with mod + LMB/RMB and dragging
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        extraConfig = # hyprlang
          ''
            # Disable keymaps (locked mode)
            bind = $mod ALT_L, H, submap, locked
            submap = locked
            bind = $mod ALT_L, H, submap, reset
            submap = reset
          '';
      }

      (
        let
          hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
          jq = "${pkgs.jq}/bin/jq";
          set-zoom-factor =
            jqFilter:
            "${hyprctl} -q keyword cursor:zoom_factor $(${hyprctl} getoption cursor:zoom_factor -j | ${jq} '${jqFilter}')";

          increase-zoom = set-zoom-factor ".float * 1.1";
          decrease-zoom = set-zoom-factor "(.float * 0.9) | if . < 1 then 1 else . end";
          reset-zoom = "${hyprctl} -q keyword cursor:zoom_factor 1";
        in
        {
          bind = [
            "$mod, mouse_down, exec, ${increase-zoom}"
            "$mod, mouse_up, exec, ${decrease-zoom}"
            "$mod SHIFT, mouse_up, exec, ${reset-zoom}"
            "$mod SHIFT, mouse_down, exec, ${reset-zoom}"
            "$mod SHIFT, minus, exec, ${reset-zoom}"
            "$mod SHIFT, KP_SUBTRACT, exec, ${reset-zoom}"
            "$mod SHIFT, 0, exec, ${reset-zoom}"
          ];
          binde = [
            "$mod, equal, exec, ${increase-zoom}"
            "$mod, minus, exec, ${decrease-zoom}"
            "$mod, KP_ADD, exec, ${increase-zoom}"
            "$mod, KP_SUBTRACT, exec, ${decrease-zoom}"
          ];
        }
      )

      {
        # sioodmy's implementation
        bind = concatLists (
          genList (
            x:
            let
              ws = toString (x + 1);
            in
            [
              "$mod, ${ws}, workspace, ${ws}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
            ]
          ) 9
        );
      }

      (lib.mkMerge (map binds.toHyprBindConfig config.gipphe.core.wm.binds))
    ];
  };
}
