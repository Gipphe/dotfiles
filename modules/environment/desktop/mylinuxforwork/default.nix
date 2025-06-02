# Setup from https://github.com/mylinuxforwork/hyprland-starter
{ util, pkgs, ... }:
util.mkToggledModule [ "environment" "desktop" ] {
  name = "mylinuxforwork";
  hm = {
    home.packages = with pkgs; [
      wget
      unzip
      git
      gum
      hyprland
      waybar
      rofi-wayland
      alacritty
      dunst
      xfce.thunar
      xdg-desktop-portal-hyprland
      qt6
      qt5
      hyprpaper
      hyprlock
      floorp
      font-awesome
      vim
      fastfetch
      fira-sans
      fira-code
      nerdfonts.fira-code
      jq
      brightnessctl
      networkmanager
      wireplumber
      wlogout
    ];
    xdg.configFile = {
      "alacritty/alacritty.toml".text = ''
        [font]
        size = 12.0

        [font.normal]
        family = "FiraCode"
        style = "Regular"

        [window]
        opacity = 0.8

        [window.padding]
        x = 15
        y = 15

        [selection]
        save_to_clipboard = true
      '';
      "dunst/dunstrc".text = ''
        [global]
          monitor = 0
          follow = 0

          width = 300
          height = (0,300)
          origin = top-center
          offset = 0x30
          scale = 0
          notification_limit = 20

          progress_bar = true
          progress_bar_height = 10
          progress_bar_frame_width = 1
          progress_bar_min_width = 150
          progress_bar_max_width = 300
          progress_bar_corner_radius = 10
          icon_corner_radius = 0
          indicate_hidden = yes
          transparency = 30
          separator_height = 2
          padding = 8
          horizontal_padding = 8
          text_icon_padding = 0
          frame_width = 1
          frame_color = "#ffffff"
          gap_size = 0
          separator_color = frame
          sort = yes

          font = "Fira Sans Semibold" 9
          line_height = 1
          markup = full
          format = "<b>%s</b>\n%b"
          alignment = left
          vertical_alignment = center
          show_age_threshold = 60
          ellipsize = middle
          ignore_newline = no
          stack_duplicates = true
          hide_duplicate_count = false
          show_indicators = yes

          enable_recursive_icon_lookup = true
          icon_theme = "Adwaita, breeze"
          icon_position = left
          min_icon_size = 32
          max_icon_size = 128
          icon_path = /usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/

          sticky_history = yes
          history_length = 20

          dmenu = ${pkgs.dmenu}/bin/dmenu -p dunst
          browser = ${pkgs.xdg-utils}/bin/xdg-open
          always_run_script = true
          title = Dunst
          class = Dunst
          corner_radius = 10
          ignore_dbusclose = false

          force_xwayland = false

          force_xinerama = false

          mouse_left_click = close_current
          mouse_middle_click = do_action, close_current
          mouse_right_click = close_all

        [experimental]
          per_monitor_dpi = false

        [urgency_low]
          background = "#000000CC"
          foreground = "#888888"
          timeout = 6

        [urgency_normal]
          background = "#000000CC"
          foreground = "#ffffff"
          timeout = 6

        [urgency_critical]
          background = "#900000CC"
          foreground = "#ffffff"
          frame_color = "#ffffff"
          timeout = 6
      '';
      "hypr/hyprland.conf".text = ''
        source = ~/.config/hypr/conf/monitor.conf
        source = ~/.config/hypr/conf/autostart.conf
        source = ~/.config/hypr/conf/cursor.conf
        source = ~/.config/hypr/conf/environments.conf
        source = ~/.config/hypr/conf/input.conf
        source = ~/.config/hypr/conf/general.conf
        source = ~/.config/hypr/conf/decoration.conf
        source = ~/.config/hypr/conf/animations.conf
        source = ~/.config/hypr/conf/layouts.conf
        source = ~/.config/hypr/conf/gestures.conf
        source = ~/.config/hypr/conf/misc.conf
        source = ~/.config/hypr/conf/windowrules.conf
        source = ~/.config/hypr/conf/binds.conf
      '';
      # TODO
      "hypr/conf/animations.conf".text =
        assert (false == true);
        ''

        '';
    };
  };
}
