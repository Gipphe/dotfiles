{
  inputs,
  util,
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (builtins)
    attrNames
    concatLists
    concatStringsSep
    genList
    isString
    toString
    ;
  inherit (lib) toLower;

  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  portalPackage =
    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

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
  toDispatch =
    action:
    if action ? spawn then
      "exec, ${action.spawn}"
    else
      abort "Unknown keybind action: ${concatStringsSep ", " (attrNames action)}";
  replaceMod =
    s:
    let
      lowered = toLower s;
    in
    if lowered == "mod" || lowered == "$mod" then "$mod" else s;
  toMods =
    mods: if isString mods then replaceMod mods else concatStringsSep " " (map replaceMod mods);
  toHyprBind = coreBind: "${toMods coreBind.mod}, ${coreBind.key}, ${toDispatch coreBind.action}";
  coreBinds = map toHyprBind config.gipphe.core.wm.binds;
in
util.mkProgram {
  name = "hyprland";
  hm = {
    home.packages = with pkgs; [ wireplumber ];
    wayland.windowManager.hyprland = {
      enable = true;
      inherit package portalPackage;
      settings = {
        "$mod" = "SUPER";

        # Monitor
        # See https://wiki.hyprland.org/Configuring/Monitors
        monitor = lib.mkDefault ",preferred,auto,1";
        bind =
          workspaces
          ++ coreBinds
          ++ [
            "$mod, Q, killactive" # Close current window
            "$mod SHIFT, Q, forcekillactive" # Force close current window
            "$mod, T, togglefloating # Toggle between tiling and floating window"
            "$mod, F, fullscreen # Open the window in fullscreen"
            "$mod, P, pseudo, # dwindle"
            "$mod, J, togglesplit, # dwindle"

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

        bindl =
          let
            hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
            lid-switch = util.writeFishApplication {
              name = "lid-switch";
              text = ''
                set -l monitors "$(${hyprctl} monitors all -j | jq 'length')"
                if test $monitors == 1
                  if test $argv[1] == "close"
                    systemctl suspend
                  else
                    sleep 1 && ${hyprctl} dispatch dpms on eDP-1
                  end
                end
              '';
            };

          in
          [
            ", switch:off:Lid Switch, exec, ${lid-switch}/bin/lid-switch open"
            ", switch:on:Lid Switch, exec, ${lid-switch}/bin/lid-switch close"
          ];

        bindm = [
          # Move/resize windows with mod + LMB/RMB and dragging
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
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
          numlock_by_default = true;

          follow_mouse = 1;

          touchpad = {
            natural_scroll = false;
          };

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification
        };

        general = {
          gaps_in = 2;
          gaps_out = 2;
          border_size = 1;
          "col.active_border" = lib.mkForce "rgb(8aadf4) rgb(c6a0f6) 45deg";
          # "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
          resize_on_border = true;
        };

        decoration = {
          rounding = 6;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            # color = "rgba(1a1a1aee)";
          };
        };

        animations = {
          enabled = true;
          bezier = [
            "myBezier, 0.05, 0.9, 0.1, 1.05"
            "easeOutQuart, 0.25, 1, 0.5, 1"
            "easeInOutExpo, 0.87, 0, 0.13, 1"
          ];
          animation = [
            "windows, 1, 3, easeOutQuart"
            "windowsOut, 1, 3, easeInOutExpo, popin 80%"
            "border, 1, 5, easeOutQuart"
            "borderangle, 1, 4, easeOutQuart"
            "fade, 1, 4, default"
            "workspaces, 1, 1, default"
          ];
        };

        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more

          # master switch for pseudotiling. Enabling is bound to mod + P in the keybinds section below
          pseudotile = true;
          # you probably want this
          preserve_split = true;
        };

        gestures = {
          workspace_swipe = true;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
      };
      xwayland.enable = true;
    };
    home.sessionVariables.NIXOS_OZONE_WL = "1";
  };
  system-nixos = {
    programs.hyprland = {
      enable = true;
      inherit package portalPackage;
    };
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
  };
}
