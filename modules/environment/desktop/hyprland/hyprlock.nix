{ util, config, ... }:
util.mkToggledModule [ "environment" "desktop" "hyprland" ] {
  name = "hyprlock";
  hm = {
    programs.hyprlock = {
      enable = true;
      settings = {
        background = {
          monitor = "";
          # path = ../../wallpaper/small-memory/wallpaper/Macchiato-hald8-wall.png;
        };

        input-field = {
          monitor = "";
          size = "200, 50";
          outline_thickness = 3;
          dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
          # outer_color = "rgb(151515)";
          # inner_color = "rgb(FFFFFF)";
          # font_color = "rgb(10, 10, 10)";
          fade_on_empty = true;
          fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered
          placeholder_text = "<i>Input password...</i>"; # Text rendered in the input box when it's empty.
          hide_input = false;
          rounding = -1; # -1 means complete rounding (circle/oval)
          # check_color = "rgb(204, 136, 34)";
          # fail_color = "rgb(204, 34, 34)"; # if authentication failed, changes outer_color and fail message color
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
          fail_transition = 300; # transition time in ms between normal outer_color and fail_color
          capslock_color = -1;
          numlock_color = -1;
          bothlock_color = -1; # when both locks are active. -1 means don't change outer_color (same for above)
          invert_numlock = false; # change color if numlock is off
          swap_font_color = false; # see below
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
  system-nixos.security.pam.services.hyprlock = { };
}
