{
  bar = {
    widgets = {
      center = [ "workspaces" ];
      end = [
        "tray"
        "notifications"
        "clipboard"
        "network"
        "bluetooth"
        "volume"
        "brightness"
        "battery"
        "control-center"
        "clock"
        "session"
      ];
      margin_edge = 0;
      margin_ends = 0;
      radius = 0;
      start = [
        "launcher"
        "wallpaper"
        "media"
        "active_window"
      ];
    };
  };
  location = {
    auto_locate = true;
  };
  lockscreen_widgets = {
    enabled = false;
    grid = {
      cell_size = 16;
      major_interval = 4;
      visible = true;
    };
    schema_version = 2;
    widget = {
      "lockscreen-login-box@DP-1" = {
        box_height = 0;
        box_width = 0;
        cx = 960;
        cy = 957;
        output = "DP-1";
        rotation = 0;
        settings = {
          background_color = "surface_variant";
          background_opacity = 0.88;
          background_radius = 12;
          input_opacity = 1;
          input_radius = 6;
          show_login_button = true;
        };
        type = "login_box";
      };
      "lockscreen-login-box@DP-2" = {
        box_height = 0;
        box_width = 0;
        cx = 960;
        cy = 957;
        output = "DP-2";
        rotation = 0;
        settings = {
          background_color = "surface_variant";
          background_opacity = 0.88;
          background_radius = 12;
          input_opacity = 1;
          input_radius = 6;
          show_login_button = true;
        };
        type = "login_box";
      };
    };
    widget_order = [
      "lockscreen-login-box@DP-1"
      "lockscreen-login-box@DP-2"
    ];
  };
  shell = {
    avatar_path = "/home/gipphe/Pictures/wallpapers/small-memory.png";
    launch_apps_as_systemd_services = true;
    panel = {
      open_near_click_control_center = true;
    };
  };
  theme = {
    builtin = "Catppuccin";
    templates = {
      builtin_ids = [ "wezterm" ];
    };
  };
  wallpaper = {
    directory = "/home/gipphe/Pictures/wallpapers";
  };
  widget = {
    brightness = {
      show_label = false;
    };
    clock = {
      format = "%H:%M";
      tooltip_format = "%A, %F";
    };
    launcher = {
      glyph = "rocket";
    };
    media = {
      title_scroll = "on_hover";
    };
    network = {
      show_label = false;
    };
    volume = {
      show_label = false;
    };
  };
}
