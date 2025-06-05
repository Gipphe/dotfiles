{
  util,
  pkgs,
  config,
  lib,
  ...
}:
let
  grimblast = lib.getExe pkgs.grimblast;
  inherit (builtins) concatLists genList toString;

  # sioodmy's implementation
  workspaces = concatLists (
    genList (
      x:
      let
        ws =
          let
            c = (x + 1) / 10;
          in
          toString (x + 1 - (c * 10));
      in
      [
        "$mod, ${ws}, workspace, ${toString (x + 1)}"
        "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    ) 10
  );

  # Hyprland docs implementation
  workspaces' = concatLists (
    genList (
      i:
      let
        ws = i + 1;
      in
      [
        "$mod, code:1${toString i}, workspace, ${toString ws}"
        "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
      ]
    ) 10
  );
  waybar = "${pkgs.waybar}/bin/waybar";
  dunst = "${config.services.dunst.package}/bin/dunst";
  hyprpaper = "${config.services.hyprpaper.package}/bin/hyprpaper";
in
util.mkToggledModule
  [
    "environment"
    "desktop"
  ]
  {
    name = "hyprland";
    hm = {
      imports = [
        ./dunst.nix
        ./filemanager.nix
        ./hypridle.nix
        ./hyprlock.nix
        ./hyprpaper.nix
        ./hyprpolkitagent.nix
        ./rofi.nix
        ./waybar.nix
        ./wlogout.nix
      ];
      home.packages = with pkgs; [ wireplumber ];
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          "$mod" = "SUPER";
          # Monitor
          # See https://wiki.hyprland.org/Configuring/Monitors
          monitor = ",preferred,auto,1";
          bind = workspaces ++ [
            "$mod, F, exec, floorp"
            ", Print, exec, ${grimblast} copy area"
            "$mod, RETURN, exec, ${config.programs.wezterm.package}/bin/wezterm"
            "CTRL SHIFT, RETURN, exec, ${config.programs.wezterm.package}/bin/wezterm"
            "$mod, Q, killactive" # Close current window
            "$mod CTRL, RETURN, exec, rofi -show drun" # Open rofi
          ];

          env = [
            # Cursor
            "XCURSOR_SIZE,24"

            # XDG Desktop Portal
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"

            # QT
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_QPA_PLATFORMTHEME,qt6ct"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            "QT_AUTO_SCREEN_SCALE_FACTOR,1"

            # GTK
            "GDK_SCALE,1"

            # Mozilla
            "MOZ_ENABLE_WAYLAND,1"

            # Disable appimage launcher by default
            "APPIMAGELAUNCHER_DISABLE,1"

            # OZONE
            "OZONE_PLATFORM,wayland"
          ];

          input = {
            kb_layout = "no";
            kb_variant = "";
            kb_model = "";
            kb_options = "";
            kb_rules = "";

            follow_mouse = 1;

            touchpad = {
              natural_scroll = false;
            };

            sensitivity = 0; # -1.0 - 1.0, 0 means no modification
          };

          general = {
            gaps_in = 5;
            gaps_out = 5;
            border_size = 1;
            # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            # "col.inactive_border" = "rgba(595959aa)";
            layout = "dwindle";
            resize_on_border = true;
          };
          #
          #
          # # Decoration
          #
          # decoration {
          #   rounding = 10
          #   blur {
          #     enable = true
          #     size = 3
          #     passes = 1
          #   }
          #
          #   shadow {
          #     enabled = true
          #     range = 4
          #     render_power = 3
          #     color = rgba(1a1a1aee)
          #   }
          # }
          #
          #
          # # Animations
          #
          # animations {
          #   enabled = true
          #   bezier = myBezier, 0.05, 0.9, 0.1, 1.05
          #   animation = windows, 1, 7, myBezier
          #   animation = windowsOut, 1, 7, default, popin 80%
          #   animation = border, 1, 10, default
          #   animation = borderangle, 1, 8, default
          #   animation = fade, 1, 7, default
          #   animation = workspaces, 1, 6, default
          # }
          #
          #
          # # Layouts
          #
          # dwindle {
          #   # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          #   pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          #   preserve_split = true # you probably want this
          # }
          #
          # # Gestures
          #
          # gestures {
          #   workspace_swipe = true
          # }
          #
          #
          # # Misc
          #
          # misc {
          #   disable_hyprland_logo = true
          #   disable_splash_rendering = true
          # }
          #
          # # Window rules
          # # No settings here yet.
          #
          #
          # # Binds
          #
          # # SUPER key
          # $mainMod = SUPER
          #
          # # Actions
          # bind = $mainMod, RETURN, exec, ${term} # Open terminal
          # bind = CTRL SHIFT, RETURN, exec, ${term}
          # bind = $mainMod, Q, killactive # Close current window
          # bind = $mainMod, M, exit # Exit Hyprland
          # bind = $mainMod, T, togglefloating # Toggle between tiling and floating window
          # bind = $mainMod, F, fullscreen # Open the window in fullscreen
          # bind = $mainMod, P, pseudo, # dwindle
          # bind = $mainMod, J, togglesplit, # dwindle
          # bind = $mainMod, B, exec, ${browser_script} # Opens the browser
          # bind = $mainMod SHIFT, B, exec, ${reload_waybar_script} # Reload waybar
          # bind = $mainMod SHIFT, W, exec, ${reload_hyprpaper_script} # Reload hyprpaper after changing wallpaper
          #
          # bind = , XF86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+
          # bind = , XF86AudioLowerVolume, exec, ${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-
          # bind = , XF86MonBrightnessUp, exec, ${brightnessctl} set 10%+
          # bind = , XF86MonBrightnessDown, exec, ${brightnessctl} set 10%-
          # bind = , XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle
          # bind = , XF86AudioMicMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle
          # bind = , XF86WLAN, exec, ${nmcli} radio wifi toggle
          # bind = , XF86Refresh, exec, ${xdotool} key F5
          #
          # # Move focus with mainMod + arrow keys
          # bind = $mainMod, left, movefocus, l # Move focus left
          # bind = $mainMod, right, movefocus, r # Move focus right
          # bind = $mainMod, up, movefocus, u # Move focus up
          # bind = $mainMod, down, movefocus, d # Move focus down
          #
          # # Switch workspaces with mainMod + [0-9]
          # bind = $mainMod, 1, workspace, 1
          # bind = $mainMod, 2, workspace, 2
          # bind = $mainMod, 3, workspace, 3
          # bind = $mainMod, 4, workspace, 4
          # bind = $mainMod, 5, workspace, 5
          # bind = $mainMod, 6, workspace, 6
          # bind = $mainMod, 7, workspace, 7
          # bind = $mainMod, 8, workspace, 8
          # bind = $mainMod, 9, workspace, 9
          # bind = $mainMod, 0, workspace, 10
          #
          # # Move active window to a workspace with mainMod + SHIFT + [0-9]
          # bind = $mainMod SHIFT, 1, movetoworkspace, 1
          # bind = $mainMod SHIFT, 2, movetoworkspace, 2
          # bind = $mainMod SHIFT, 3, movetoworkspace, 3
          # bind = $mainMod SHIFT, 4, movetoworkspace, 4
          # bind = $mainMod SHIFT, 5, movetoworkspace, 5
          # bind = $mainMod SHIFT, 6, movetoworkspace, 6
          # bind = $mainMod SHIFT, 7, movetoworkspace, 7
          # bind = $mainMod SHIFT, 8, movetoworkspace, 8
          # bind = $mainMod SHIFT, 9, movetoworkspace, 9
          # bind = $mainMod SHIFT, 0, movetoworkspace, 10
          #
          # # Scroll through existing workspaces with mainMod + scroll
          # bind = $mainMod, mouse_down, workspace, e+1
          # bind = $mainMod, mouse_up, workspace, e-1
          #
          # # Move/resize windows with mainMod + LMB/RMB and dragging
          # bindm = $mainMod, mouse:272, movewindow
          # bindm = $mainMod, mouse:273, resizewindow
        };
        xwayland.enable = true;
      };
      home.sessionVariables.NIXOS_OZONE_WL = "1";
    };
    system-nixos = {
      programs.hyprland.enable = true;
    };
  }
