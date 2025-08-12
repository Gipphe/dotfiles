{
  util,
  lib,
  pkgs,
  config,
  ...
}:
util.mkProgram {
  name = "hyprlock";
  hm = {
    options.gipphe.programs.hyprlock.package = lib.mkPackageOption pkgs "hyprlock" { } // {
      default = config.programs.hyprlock.package;
    };
    config = {
      programs.hyprlock = {
        inherit (config.gipphe.programs.hyprland) enable;
        settings = {
          background = {
            monitor = "";
            # path = ../../wallpaper/small-memory/wallpaper/Macchiato-hald8-wall.png;
            path = lib.mkForce "screenshot";
            blur_passes = 3;
            blur_size = 5;
          };

          input-field = {
            monitor = "";
            size = "300, 50";
            outline_thickness = 3;
            # Scale of input-field height, 0.2 - 0.8
            dots_size = 0.33;
            # Scale of dots' absolute size, 0.0 - 1.0
            dots_spacing = 0.15;
            dots_center = true;
            # -1 default circle, -2 follow input-field rounding
            dots_rounding = -1;
            # outer_color = "rgb(151515)";
            # inner_color = "rgb(FFFFFF)";
            # font_color = "rgb(10, 10, 10)";
            fade_on_empty = true;
            # Milliseconds before fade_on_empty is triggered
            fade_timeout = 1000;
            # Text rendered in the input box when it's empty.
            placeholder_text = "<i>Input password...</i>";
            hide_input = false;
            # -1 means complete rounding (circle/oval)
            rounding = -1;
            # check_color = "rgb(204, 136, 34)";
            # if authentication failed, changes outer_color and fail message color
            # fail_color = "rgb(204, 34, 34)";
            # can be set to empty
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
            # transition time in ms between normal outer_color and fail_color
            fail_transition = 300;
            capslock_color = "rgb(f5c8b0)";
            numlock_color = -1;
            # when both locks are active. -1 means don't change outer_color (same for above)
            bothlock_color = "rgb(f5c8b0)";
            # change color if numlock is off
            invert_numlock = false;
            # see below
            swap_font_color = false;
            position = "0, -20";
            halign = "center";
            valign = "center";
          };

          label = [
            {
              # clock
              monitor = "";
              text = "cmd[update:1000] echo \"$TIME\"";
              color = "rgba(200, 200, 200, 1.0)";
              font_size = 55;
              font_family = "Fira Semibold";
              position = "-100, 40";
              halign = "right";
              valign = "bottom";
              shadow_passes = 5;
              shadow_size = 10;
            }
            {
              # username
              monitor = "";
              text = "$USER";
              color = "rgba(200, 200, 200, 1.0)";
              font_size = 20;
              font_family = "Fira Semibold";
              position = "-100, 160";
              halign = "right";
              valign = "bottom";
              shadow_passes = 5;
              shadow_size = 10;
            }
          ];
        };
      };
      wayland.windowManager.hyprland.settings.bind = [
        "$mod,L,exec,${config.programs.hyprlock.package}/bin/hyprlock"
      ];
    };
  };
  system-nixos.security.pam.services.hyprlock = { };
}
