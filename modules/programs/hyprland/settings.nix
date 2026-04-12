{
  inputs,
  pkgs,
  lib,
  util,
  ...
}:
let
  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  portalPackage =
    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
in
util.mkProgram {
  name = "hyprland";
  hm = {
    imports = [
      ./binds.nix
      ./input.nix
      ./triggers.nix
      ./env.nix
    ];
    config = {
      gipphe.core.wm.actions =
        let
          hyprctl = lib.getExe' package "hyprctl";
        in
        {
          monitors-on = "${hyprctl} dispatch dpms on";
          monitors-off = "${hyprctl} dispatch dpms off";
        };
      wayland.windowManager.hyprland = {
        enable = true;
        inherit package portalPackage;
        settings = {
          "$mod" = "SUPER";

          monitor = lib.mkDefault ",preferred,auto,1";

          cursor.no_hardware_cursors = true;

          general = {
            gaps_in = 2;
            gaps_out = 2;
            border_size = 1;
            "col.active_border" = lib.mkForce "rgb(8aadf4) rgb(c6a0f6) 45deg";
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
              "workspaces, 1, 1, default, slidevert"
            ];
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };

          gestures = {
            workspace_swipe_touch = true;
            workspace_swipe_create_new = true;
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };

          workspace = [
            "w[tv1]s[false], gapsout:0, gapsin:0"
            "f[1]s[false], gapsout:0, gapsin:0"
          ];
          windowrule = [
            "border_size 0, match:float 0, match:workspace w[tv1]s[false]"
            "rounding 0, match:float 0, match:workspace w[tv1]s[false]"
            "border_size 0, match:float 0, match:workspace f[1]s[false]"
            "rounding 0, match:float 0, match:workspace f[1]s[false]"
          ];
        };
        extraConfig = /* hyprlang */ ''
          # Disable keymaps (locked mode)
          bind = $mod ALT_L, H, submap, locked
          submap = locked
          bind = $mod ALT_L, H, submap, reset
          submap = reset
        '';
        xwayland.enable = true;
      };
    };
  };
  system-nixos = {
    programs.hyprland = {
      enable = true;
      inherit package portalPackage;
    };
  };
}
