# Setup from https://github.com/mylinuxforwork/hyprland-starter
{
  util,
  pkgs,
  ...
}:
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
    xdg.configFile =
      let
        ml4w_repo = pkgs.fetchFromGitHub {
          owner = "mylinuxforwork";
          repo = "hyprland-starter";
          rev = "master";
          hash = "";
        };
        waybar = "${pkgs.waybar}/bin/waybar";
        hyprpaper = "${pkgs.hyprpaper}/bin/hyprpaper";
        dunst = "${pkgs.dunst}/bin/dunst";
        term = "${pkgs.wezterm}/bin/wezterm";
        thunar = "${pkgs.xfce.thunar}/bin/thunar";
        floorp = "${pkgs.floorp}/bin/floorp";
        killall = "${pkgs.killall}/bin/killall";
        wpctl = "${pkgs.wireplumber}/bin/wpctl";
        brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
        nmcli = "${pkgs.networkmanager}/bin/nmcli";
        xdotool = "${pkgs.xdotool}/bin/xdotool";

        file_manager_script = thunar;
        browser_script = floorp;
        reload_hyprpaper_script = pkgs.writeShellScriptBin "reload-hyprpaper.sh" ''
          ${killall} hyprpaper
          sleep 1
          ${hyprpaper} &
        '';
        reload_waybar_script = pkgs.writeShellScriptBin "reload-waybar.sh" ''
          ${killall} -9 waybar
          sleep 1
          ${waybar} &
        '';
      in
      {
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
          # Monitor
          # See https://wiki.hyprland.org/Configuring/Monitors
          monitor=,preferred,auto,1


          # Autostart
          exec-once = ${waybar}
          exec-once = ${hyprpaper}
          exec-once = ${dunst}

          exec = ~/.config/ml4w-hyprland-settings/hyprctl.sh


          # Cursor
          env = XCURSOR_SIZE,24


          # Environments

          # XDG Desktop Portal
          env = XDG_CURRENT_DESKTOP,Hyprland
          env = XDG_SESSION_TYPE,wayland
          env = XDG_SESSION_DESKTOP,Hyprland

          # QT
          env = QT_QPA_PLATFORM,wayland;xcb
          env = QT_QPA_PLATFORMTHEME,qt6ct
          env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
          env = QT_AUTO_SCREEN_SCALE_FACTOR,1

          # GTK
          env = GDK_SCALE,1

          # Mozilla
          env = MOZ_ENABLE_WAYLAND,1

          # Disable appimage launcher by default
          env = APPIMAGELAUNCHER_DISABLE,1

          # OZONE
          env = OZONE_PLATFORM,wayland


          # Input

          input {
            kb_layout = no
            kb_variant =
            kb_model =
            kb_options =
            kb_rules =

            follow_mouse = 1

            touchpad {
              natural_scroll = false
            }

            sensitivity = 0 # -1.0 - 1.0, 0 means no modification
          }


          # General

          general {
            gaps_in = 5
            gaps_out = 20
            border_size = 2
            col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
            col.inactive_border = rgba(595959aa)
            layout = dwindle
            resize_on_border = true
          }


          # Decoration

          decoration {
            rounding = 10
            blur {
              enable = true
              size = 3
              passes = 1
            }

            shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1aee)
            }
          }


          # Animations

          animations {
            enabled = true
            bezier = myBezier, 0.05, 0.9, 0.1, 1.05
            animation = windows, 1, 7, myBezier
            animation = windowsOut, 1, 7, default, popin 80%
            animation = border, 1, 10, default
            animation = borderangle, 1, 8, default
            animation = fade, 1, 7, default
            animation = workspaces, 1, 6, default
          }


          # Layouts

          dwindle {
            # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
            pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = true # you probably want this
          }

          # Gestures

          gestures {
            workspace_swipe = true
          }


          # Misc

          misc {
            disable_hyprland_logo = true
            disable_splash_rendering = true
          }

          # Window rules
          # No settings here yet.


          # Binds

          # SUPER key
          $mainMod = SUPER

          # Actions
          bind = $mainMod, RETURN, exec, ${term} # Open terminal
          bind = CTRL SHIFT, RETURN, exec, ${term}
          bind = $mainMod, Q, killactive # Close current window
          bind = $mainMod, M, exit # Exit Hyprland
          bind = $mainMod, E, exec, ${file_manager_script} # Opens the file manager
          bind = $mainMod, T, togglefloating # Toggle between tiling and floating window
          bind = $mainMod, F, fullscreen # Open the window in fullscreen
          bind = $mainMod CTRL, RETURN, exec, rofi -show drun # Open rofi
          bind = $mainMod, P, pseudo, # dwindle
          bind = $mainMod, J, togglesplit, # dwindle
          bind = $mainMod, B, exec, ${browser_script} # Opens the browser
          bind = $mainMod SHIFT, B, exec, ${reload_waybar_script} # Reload waybar
          bind = $mainMod SHIFT, W, exec, ${reload_hyprpaper_script} # Reload hyprpaper after changing wallpaper
          bind = , XF86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+
          bind = , XF86AudioLowerVolume, exec, ${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-
          bind = , XF86MonBrightnessUp, exec, ${brightnessctl} set 10%+
          bind = , XF86MonBrightnessDown, exec, ${brightnessctl} set 10%-
          bind = , XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle
          bind = , XF86AudioMicMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle
          bind = , XF86WLAN, exec, ${nmcli} radio wifi toggle
          bind = , XF86Refresh, exec, ${xdotool} key F5

          # Move focus with mainMod + arrow keys
          bind = $mainMod, left, movefocus, l # Move focus left
          bind = $mainMod, right, movefocus, r # Move focus right
          bind = $mainMod, up, movefocus, u # Move focus up
          bind = $mainMod, down, movefocus, d # Move focus down

          # Switch workspaces with mainMod + [0-9]
          bind = $mainMod, 1, workspace, 1
          bind = $mainMod, 2, workspace, 2
          bind = $mainMod, 3, workspace, 3
          bind = $mainMod, 4, workspace, 4
          bind = $mainMod, 5, workspace, 5
          bind = $mainMod, 6, workspace, 6
          bind = $mainMod, 7, workspace, 7
          bind = $mainMod, 8, workspace, 8
          bind = $mainMod, 9, workspace, 9
          bind = $mainMod, 0, workspace, 10

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          bind = $mainMod SHIFT, 1, movetoworkspace, 1
          bind = $mainMod SHIFT, 2, movetoworkspace, 2
          bind = $mainMod SHIFT, 3, movetoworkspace, 3
          bind = $mainMod SHIFT, 4, movetoworkspace, 4
          bind = $mainMod SHIFT, 5, movetoworkspace, 5
          bind = $mainMod SHIFT, 6, movetoworkspace, 6
          bind = $mainMod SHIFT, 7, movetoworkspace, 7
          bind = $mainMod SHIFT, 8, movetoworkspace, 8
          bind = $mainMod SHIFT, 9, movetoworkspace, 9
          bind = $mainMod SHIFT, 0, movetoworkspace, 10

          # Scroll through existing workspaces with mainMod + scroll
          bind = $mainMod, mouse_down, workspace, e+1
          bind = $mainMod, mouse_up, workspace, e-1

          # Move/resize windows with mainMod + LMB/RMB and dragging
          bindm = $mainMod, mouse:272, movewindow
          bindm = $mainMod, mouse:273, resizewindow
        '';

        "hypr/hyprlock.conf".text = ''
          background {
            monitor =
            path = ${../../wallpaper/small-memory/wallpaper/Macchiato-hald8-wall.png}
          }

          input-field {
            monitor =
            size = 200, 50
            outline_thickness = 3
            dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
            dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
            dots_center = true
            dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
            outer_color = rgb(151515)
            inner_color = rgb(FFFFFF)
            font_color = rgb(10, 10, 10)
            fade_on_empty = true
            fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered
            placeholder_text = <i>Input password...</i> # Text rendered in the input box when it's empty.
            hide_input = false
            rounding = -1 # -1 means complete rounding (circle/oval)
            check_color = rgb(204, 136, 34)
            fail_color = rgb(204, 34, 34) # if authentication failed, changes outer_color and fail message color
            fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
            fail_transition = 300 # transition time in ms between normal outer_color and fail_color
            capslock_color = -1
            numlock_color = -1
            bothlock_color = -1 # when both locks are active. -1 means don't change outer_color (same for above)
            invert_numlock = false # change color if numlock is off
            swap_font_color = false # see below
            position = 0, -20
            halign = center
            valign = center
          }

          label {
            monitor =
            #clock
            text = cmd[update:1000] echo "$TIME"
            color = rgba(200, 200, 200, 1.0)
            font_size = 55
            font_family = Fira Semibold
            position = -100, 40
            halign = right
            valign = bottom
            shadow_passes = 5
            shadow_size = 10
          }

          label {
            monitor =
            text = $USER
            color = rgba(200, 200, 200, 1.0)
            font_size = 20
            font_family = Fira Semibold
            position = -100, 160
            halign = right
            valign = bottom
            shadow_passes = 5
            shadow_size = 10
          }
        '';
        "hypr/hyprpaper.conf".text = ''
          preload = ${../../wallpaper/small-memory/wallpaper/Macchiato-hald8-wall.png}
          wallpaper = ,${../../wallpaper/small-memory/wallpaper/Macchiato-hald8-wall.png}
          splash = false
        '';
        "ml4w/apps/ML4W_Hyprland_Settings-x86_64.AppImage".source =
          "${ml4w_repo}/dotfiles/.config/ml4w/apps/ML4W_Hyprland_Settings-x86_64.AppImage";
        "ml4w/scripts/keybindings.sh".source = pkgs.writeShellScriptBin "keybindings.sh" ''
          config_file=~/.config/ml4w/scripts/keybindings.conf
          echo "Reading from: $config_file"

          keybinds=""

          # Detect Start String
          while read -r line; do
            if [[ "$line" == "bind" ]]; then
              line="$(echo "$line" | sed 's/$mainMod/SUPER/g')"
              line="$(echo "$line" | sed 's/bind = //g')"
              line="$(echo "$line" | sed 's/bindm = //g')"

              IFS='#'
              read -a strarr <<<"$line"
              kb_str=''${strarr[0]}
              cm_str=''${strarr[1]}

              IFS=','
              read -a kbarr <<<"$kb_str"

              item="''${kbarr[0]}  + ''${kbarr[1]}"$'\r'"''${cm_str:1}"
              keybinds=$keybinds$item$'\n'
            fi
          done < "$config_file"

          sleep 0.2
          rofi -dmenu -i -makrup -eh 2 -replace -p "Keybinds" <<< "$keybinds"
        '';
        "ml4w/settings/waybar-quicklinks.json".text = ''
          {
            "custom/quicklink1": {
              "format": " ",
              "on-click": "~/.config/ml4w/apps/ML4W_Hyprland_Settings-x86_64.AppImage",
              "tooltip-format": "Open Hyprland Settings"
            },
            "custom/quicklink2": {
              "format": " ",
              "on-click": "~/.config/ml4w/settings/browser.sh",
              "tooltip-format": "Open the browser"
            },
            "custom/quicklink3": {
              "format": " ",
              "on-click": "~/.config/ml4w/settings/filemanager.sh",
              "tooltip-format": "Open the filemanager"
            },
            "custom/quicklinkempty": {},
            "group/quicklinks": {
              "orientation": "horizontal",
              "modules": [
                "custom/quicklink1",
                "custom/quicklink2",
                "custom/quicklink3",
                "custom/quicklinkempty"
              ]
            }
          }
        '';
        "rofi/config.rasi".text = ''
          * {
            background: rgba(0,0,1,0.5);
            foreground: #FFFFFF;
            color0:     #0A121B;
            color1:     #056F93;
            color2:     #039AA5;
            color3:     #02C2BC;
            color4:     #02A4D2;
            color5:     #01AFEE;
            color6:     #01D3D2;
            color7:     #77e8e1;
            color8:     #53a29d;
            color9:     #056F93;
            color10:    #039AA5;
            color11:    #02C2BC;
            color12:    #02A4D2;
            color13:    #01AFEE;
            color14:    #01D3D2;
            color15:    #77e8e1;
          }

          * { border-width: 3px; }

          configuration {
            modi:                       "drun,run";
            font:                       "Fira Sans 11";
            show-icons:                 false;
            icon-theme:                 "kora";
            display-drun:               "APPS";
            display-run:                "RUN";
            display-filebrowser:        "FILES";
            display-window:             "WINDOW";
            hover-select:               false;
            scroll-method:              1;
            me-select-entry:            "";
            me-accept-entry:            "MousePrimary";
            drun-display-format:        "{name}";
            window-format:              "{w} · {c} · {t}";
          }

          window {
            width:                        600px;
            x-offset:                     0px;
            y-offset:                     65px;
            spacing:                      0px;
            padding:                      0px;
            margin:                       0px;
            color:                        #FFFFFF;
            border:                       @border-width;
            border-color:                 #FFFFFF;
            cursor:                       "default";
            transparency:                 "real";
            location:                     north;
            anchor:                       north;
            fullscreen:                   false;
            enabled:                      true;
            border-radius:                10px;
            background-color:             transparent;
          }

          /* ---- Mainbox ---- */
          mainbox {
            enabled:                      true;
            orientation:                  horizontal;
            spacing:                      0px;
            margin:                       0px;
            background-color:             @background;
            children:                     ["listbox"];
          }

          /* ---- Imagebox ---- */
          imagebox {
            padding:                      18px;
            background-color:             transparent;
            orientation:                  vertical;
            children:                     [ "inputbar", "dummy", "mode-switcher" ];
          }

          /* ---- Listbox ---- */
          listbox {
            spacing:                     20px;
            background-color:            transparent;
            orientation:                 vertical;
            children:                    [ "inputbar", "message", "listview" ];
          }

          /* ---- Dummy ---- */
          dummy {
            background-color:            transparent;
          }

          /* ---- Inputbar ---- */
          inputbar {
            enabled:                      true;
            text-color:                   @foreground;
            spacing:                      10px;
            padding:                      15px;
            border-radius:                0px;
            border-color:                 @foreground;
            background-color:             @background;
            children:                     [ "textbox-prompt-colon", "entry" ];
          }

          textbox-prompt-colon {
            enabled:                      true;
            expand:                       false;
            padding:                      0px 5px 0px 0px;
            str:                          "";
            background-color:             transparent;
            text-color:                   inherit;
          }

          entry {
            enabled:                      true;
            background-color:             transparent;
            text-color:                   inherit;
            cursor:                       text;
            placeholder:                  "Search";
            placeholder-color:            inherit;
          }

          /* ---- Mode Switcher ---- */
          mode-switcher{
            enabled:                      true;
            spacing:                      20px;
            background-color:             transparent;
            text-color:                   @foreground;
          }

          button {
            padding:                      10px;
            border-radius:                10px;
            background-color:             @background;
            text-color:                   inherit;
            cursor:                       pointer;
            border:                       0px;
          }

          button selected {
            background-color:             @color11;
            text-color:                   @foreground;
          }

          /* ---- Listview ---- */
          listview {
            enabled:                      true;
            columns:                      1;
            lines:                        8;
            cycle:                        false;
            dynamic:                      false;
            scrollbar:                    false;
            layout:                       vertical;
            reverse:                      false;
            fixed-height:                 true;
            fixed-columns:                true;
            spacing:                      0px;
            padding:                      10px;
            margin:                       0px;
            background-color:             @background;
            border:0px;
          }

          /* ---- Element ---- */
          element {
            enabled:                      true;
            padding:                      10px;
            margin:                       5px;
            cursor:                       pointer;
            background-color:             @background;
            border-radius:                10px;
            border:                       @border-width;
          }

          element normal.normal {
            background-color:            inherit;
            text-color:                  @foreground;
          }

          element normal.urgent {
            background-color:            inherit;
            text-color:                  @foreground;
          }

          element normal.active {
            background-color:            inherit;
            text-color:                  @foreground;
          }

          element selected.normal {
            background-color:            @color11;
            text-color:                  @foreground;
          }

          element selected.urgent {
            background-color:            inherit;
            text-color:                  @foreground;
          }

          element selected.active {
            background-color:            inherit;
            text-color:                  @foreground;
          }

          element alternate.normal {
            background-color:            inherit;
            text-color:                  @foreground;
          }

          element alternate.urgent {
            background-color:            inherit;
            text-color:                  @foreground;
          }

          element alternate.active {
            background-color:            inherit;
            text-color:                  @foreground;
          }

          element-icon {
            background-color:            transparent;
            text-color:                  inherit;
            size:                        32px;
            cursor:                      inherit;
          }

          element-text {
            background-color:            transparent;
            text-color:                  inherit;
            cursor:                      inherit;
            vertical-align:              0.5;
            horizontal-align:            0.0;
          }

          /*****----- Message -----*****/
          message {
            background-color:            transparent;
            border:0px;
            margin:20px 0px 0px 0px;
            padding:0px;
            spacing:0px;
            border-radius: 10px;
          }

          textbox {
            padding:                     15px;
            margin:                      0px;
            border-radius:               0px;
            background-color:            @background;
            text-color:                  @foreground;
            vertical-align:              0.5;
            horizontal-align:            0.0;
          }

          error-message {
            padding:                     15px;
            border-radius:               20px;
            background-color:            @background;
            text-color:                  @foreground;
          }
        '';
        "waybar/config".text = ''
          {
              // "layer": "top", // Waybar at top layer

              // "position": "bottom", // Waybar position (top|bottom|left|right)

              "height": 30, // Waybar height (to be removed for auto height)
              // "width": 1280, // Waybar width

              "spacing": 4, // Gaps between modules (4px)
              // Choose the order of the modules

              // Load Modules
              "include": [
                  "~/.config/ml4w/settings/waybar-quicklinks.json",
                  "~/.config/waybar/modules.json"
              ],
              "modules-left": [
                  "custom/appmenu",
                  "group/quicklinks",
                  "hyprland/window"
              ],
              "modules-center": [
                  "hyprland/workspaces"
              ],
              "modules-right": [
                  "mpd",
                  "pulseaudio",
                  "network",
                  "cpu",
                  "memory",
                  "keyboard-state",
                  "battery",
                  "clock",
                  "tray",
                  "custom/exit"
              ]
          }
        '';
        "waybar/modules.json".text = ''
          {
              // Workspaces
              "hyprland/workspaces" : {
                  "on-click": "activate",
                  "active-only": false,
                  "all-outputs": true,
                  "format": "{}",
                  "format-icons": {
                      "urgent": "",
                      "active": "",
                      "default": ""
                  },
                  "persistent-workspaces": {
                      "*": 5
                  }
              },

              // Hyprland Window
              "hyprland/window": {
                  "rewrite": {
                      "(.*) - Brave": "$1",
                      "(.*) - Chromium": "$1",
                      "(.*) - Brave Search": "$1",
                      "(.*) - Outlook": "$1",
                      "(.*) Microsoft Teams": "$1"
                  },
                  "separate-outputs": true
              },

              // Rofi Application Launcher
              "custom/appmenu": {
                  "format": "Apps",
                  "tooltip-format": "Left: Open the application launcher\nRight: Show all keybindings",
                  "on-click": "rofi -show drun -replace",
                  "on-click-right": "~/.config/ml4w/scripts/keybindings.sh",
                  "tooltip": false
              },

              // Power Menu
              "custom/exit": {
                  "format": "",
                  "tooltip-format": "Powermenu",
                  "on-click": "wlogout -b 4",
                  "tooltip": false
              },

              // Keyboard State
              "keyboard-state": {
                  "numlock": true,
                  "capslock": true,
                  "format": "{name} {icon}",
                  "format-icons": {
                      "locked": "",
                      "unlocked": ""
                  }
              },

              // System tray
              "tray": {
                  // "icon-size": 21,
                  "spacing": 10
              },

              // Clock
              "clock": {
                  // "timezone": "America/New_York",
                  "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
                  "format-alt": "{:%Y-%m-%d}"
              },

              // System
              "custom/system": {
                  "format": "",
                  "tooltip": false
              },

              // CPU
              "cpu": {
                  "format": "/ C {usage}% ",
                  "on-click": "alacritty -e htop"
              },

              // Memory
              "memory": {
                  "format": "/ M {}% ",
                  "on-click": "alacritty -e htop"
              },

              // Harddisc space used
              "disk": {
                  "interval": 30,
                  "format": "D {percentage_used}% ",
                  "path": "/",
                  "on-click": "alacritty -e htop"
              },

              "hyprland/language": {
                  "format": "/ K {short}"
              },

              // Group Hardware
              "group/hardware": {
                  "orientation": "inherit",
                  "drawer": {
                      "transition-duration": 300,
                      "children-class": "not-memory",
                      "transition-left-to-right": false
                  },
                  "modules": [
                      "custom/system",
                      "disk",
                      "cpu",
                      "memory",
                      "hyprland/language"
                  ]
              },

             // Network
              "network": {
                  "format": "{ifname}",
                  "format-wifi": "   {signalStrength}%",
                  "format-ethernet": "  {ipaddr}",
                  "format-disconnected": "Not connected", //An empty format will hide the module.
                  "tooltip-format": " {ifname} via {gwaddri}",
                  "tooltip-format-wifi": "   {essid} ({signalStrength}%)",
                  "tooltip-format-ethernet": "  {ifname} ({ipaddr}/{cidr})",
                  "tooltip-format-disconnected": "Disconnected",
                  "max-length": 50,
                  "on-click": "alacritty -e nmtui"
              },

              // Battery
              "battery": {
                  "states": {
                      // "good": 95,
                      "warning": 30,
                      "critical": 15
                  },
                  "format": "{icon}   {capacity}%",
                  "format-charging": "  {capacity}%",
                  "format-plugged": "  {capacity}%",
                  "format-alt": "{icon}  {time}",
                  // "format-good": "", // An empty format will hide the module
                  // "format-full": "",
                  "format-icons": [" ", " ", " ", " ", " "]
              },

              // Pulseaudio
              "pulseaudio": {
                  // "scroll-step": 1, // %, can be a float
                  "format": "{icon}  {volume}%",
                  "format-bluetooth": "{volume}% {icon} {format_source}",
                  "format-bluetooth-muted": " {icon} {format_source}",
                  "format-muted": " {format_source}",
                  "format-source": "{volume}% ",
                  "format-source-muted": "",
                  "format-icons": {
                      "headphone": "",
                      "hands-free": "",
                      "headset": "",
                      "phone": "",
                      "portable": "",
                      "car": "",
                      "default": ["", " ", " "]
                  },
                  "on-click": "pavucontrol"
              },

              // Bluetooth
              "bluetooth": {
                  "format-disabled": "",
                  "format-off": "",
                  "interval": 30,
                  "on-click": "blueman-manager",
                  "format-no-controller": ""
              },

              // Other
              "user": {
                  "format": "{user}",
                  "interval": 60,
                  "icon": false,
              },

              // Idle Inhibator
              "idle_inhibitor": {
                  "format": "{icon}",
                  "tooltip": true,
                  "format-icons":{
                      "activated": "",
                      "deactivated": ""
                  },
                  "on-click-right": "hyprlock"
              }
          }
        '';
        "waybar/style.css".text = ''
          /*
           * __        __          _                  ____  _         _
           * \ \      / /_ _ _   _| |__   __ _ _ __  / ___|| |_ _   _| | ___
           *  \ \ /\ / / _` | | | | '_ \ / _` | '__| \___ \| __| | | | |/ _ \
           *   \ V  V / (_| | |_| | |_) | (_| | |     ___) | |_| |_| | |  __/
           *    \_/\_/ \__,_|\__, |_.__/ \__,_|_|    |____/ \__|\__, |_|\___|
           *                 |___/                              |___/
           *
           * by Stephan Raabe (2024)
           * -----------------------------------------------------
          */

          @define-color backgroundlight #FFFFFF;
          @define-color backgrounddark #FFFFFF;
          @define-color workspacesbackground1 #FFFFFF;
          @define-color workspacesbackground2 #CCCCCC;
          @define-color bordercolor #FFFFFF;
          @define-color textcolor1 #000000;
          @define-color textcolor2 #000000;
          @define-color textcolor3 #FFFFFF;
          @define-color iconcolor #FFFFFF;

          /* -----------------------------------------------------
           * General
           * ----------------------------------------------------- */

          * {
              font-family: "Fira Sans Semibold", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
              border: none;
              border-radius: 0px;
          }

          window#waybar {
              background-color: rgba(0,0,0,0.2);
              border-bottom: 0px solid #ffffff;
              /* color: #FFFFFF; */
              transition-property: background-color;
              transition-duration: .5s;
          }

          /* -----------------------------------------------------
           * Workspaces
           * ----------------------------------------------------- */

          #workspaces {
              margin: 5px 1px 6px 1px;
              padding: 0px 1px;
              border-radius: 15px;
              border: 0px;
              font-weight: bold;
              font-style: normal;
              font-size: 16px;
              color: @textcolor1;
          }

          #workspaces button {
              padding: 0px 5px;
              margin: 4px 3px;
              border-radius: 15px;
              border: 0px;
              color: @textcolor3;
              transition: all 0.3s ease-in-out;
          }

          #workspaces button.active {
              color: @textcolor1;
              background: @workspacesbackground2;
              border-radius: 15px;
              min-width: 40px;
              transition: all 0.3s ease-in-out;
          }

          #workspaces button:hover {
              color: @textcolor1;
              background: @workspacesbackground2;
              border-radius: 15px;
          }

          /* -----------------------------------------------------
           * Tooltips
           * ----------------------------------------------------- */

          tooltip {
              border-radius: 10px;
              background-color: @backgroundlight;
              opacity:0.8;
              padding:20px;
              margin:0px;
          }

          tooltip label {
              color: @textcolor2;
          }

          /* -----------------------------------------------------
           * Window
           * ----------------------------------------------------- */

          #window {
              background: @backgroundlight;
              margin: 10px 15px 10px 0px;
              padding: 2px 10px 0px 10px;
              border-radius: 12px;
              color:@textcolor2;
              font-size:16px;
              font-weight:normal;
          }

          window#waybar.empty #window {
              background-color:transparent;
          }

          /* -----------------------------------------------------
           * Taskbar
           * ----------------------------------------------------- */

          #taskbar {
              background: @backgroundlight;
              margin: 6px 15px 6px 0px;
              padding:0px;
              border-radius: 15px;
              font-weight: normal;
              font-style: normal;
              border: 3px solid @backgroundlight;
          }

          #taskbar button {
              margin:0;
              border-radius: 15px;
              padding: 0px 5px 0px 5px;
          }

          /* -----------------------------------------------------
           * Modules
           * ----------------------------------------------------- */

          .modules-left > widget:first-child > #workspaces {
              margin-left: 0;
          }

          .modules-right > widget:last-child > #workspaces {
              margin-right: 0;
          }

          /* -----------------------------------------------------
           * Custom Quicklinks
           * ----------------------------------------------------- */

          #custom-browser,
          #custom-filemanager,
          #network,
          #pulseaudio,
          #battery,
          #custom-appmenu,
          #clock {
              margin-right: 20px;
              font-size: 20px;
              font-weight: bold;
              color: @iconcolor;
              padding: 4px 10px 2px 10px;
              font-size: 16px;
          }

          #custom-quicklink1,
          #custom-quicklink2,
          #custom-quicklink3,
          #custom-quicklink4,
          #custom-quicklink5,
          #custom-quicklink6,
          #custom-quicklink7,
          #custom-quicklink8,
          #custom-quicklink9,
          #custom-quicklink10 {
              padding:0px;
              margin-right: 7px;
              font-size:20px;
              color: @iconcolor;
          }

          /* -----------------------------------------------------
           * Custom Modules
           * ----------------------------------------------------- */

          #custom-appmenu {
              background-color: @backgrounddark;
              color: @textcolor1;
              border-radius: 15px;
              margin: 10px 10px 10px 10px;
          }

          /* -----------------------------------------------------
           * Custom Exit
           * ----------------------------------------------------- */

          #custom-exit {
              margin: 2px 20px 0px 0px;
              padding:0px;
              font-size:20px;
              color: @iconcolor;
          }

          /* -----------------------------------------------------
           * Hardware Group
           * ----------------------------------------------------- */

           #disk,#memory,#cpu,#language {
              margin:0px;
              padding:0px;
              font-size:16px;
              color:@iconcolor;
          }

          #language {
              margin-right:10px;
          }

          /* -----------------------------------------------------
           * Clock
           * ----------------------------------------------------- */

          #clock {
              background-color: @backgrounddark;
              font-size: 16px;
              color: @textcolor1;
              border-radius: 15px;
              margin: 10px 7px 10px 0px;
          }

          /* -----------------------------------------------------
           * Pulseaudio
           * ----------------------------------------------------- */

          #pulseaudio {
              background-color: @backgroundlight;
              font-size: 16px;
              color: @textcolor2;
              border-radius: 15px;
              margin: 10px 10px 10px 0px;
          }

          #pulseaudio.muted {
              background-color: @backgrounddark;
              color: @textcolor1;
          }

          /* -----------------------------------------------------
           * Network
           * ----------------------------------------------------- */

          #network {
              background-color: @backgroundlight;
              font-size: 16px;
              color: @textcolor2;
              border-radius: 15px;
              margin: 10px 10px 10px 0px;
          }

          #network.ethernet {
              background-color: @backgroundlight;
              color: @textcolor2;
          }

          #network.wifi {
              background-color: @backgroundlight;
              color: @textcolor2;
          }

          /* -----------------------------------------------------
           * Bluetooth
           * ----------------------------------------------------- */

           #bluetooth, #bluetooth.on, #bluetooth.connected {
              background-color: @backgroundlight;
              font-size: 16px;
              color: @textcolor2;
              border-radius: 15px;
              margin: 10px 15px 10px 0px;
          }

          #bluetooth.off {
              background-color: transparent;
              padding: 0px;
              margin: 0px;
          }

          /* -----------------------------------------------------
           * Battery
           * ----------------------------------------------------- */

          #battery {
              background-color: @backgroundlight;
              font-size: 16px;
              color: @textcolor2;
              border-radius: 15px;
              margin: 10px 15px 10px 0px;
          }

          #battery.charging, #battery.plugged {
              color: @textcolor2;
              background-color: @backgroundlight;
          }

          @keyframes blink {
              to {
                  background-color: @backgroundlight;
                  color: @textcolor2;
              }
          }

          #battery.critical:not(.charging) {
              background-color: #f53c3c;
              color: @textcolor3;
              animation-name: blink;
              animation-duration: 0.5s;
              animation-timing-function: linear;
              animation-iteration-count: infinite;
              animation-direction: alternate;
          }

          /* -----------------------------------------------------
           * Tray
           * ----------------------------------------------------- */

          #tray {
              margin:0px 10px 0px 0px;
          }

          #tray > .passive {
              -gtk-icon-effect: dim;
          }

          #tray > .needs-attention {
              -gtk-icon-effect: highlight;
              background-color: #eb4d4b;
          }

          /* -----------------------------------------------------
           * Other
           * ----------------------------------------------------- */

          label:focus {
              background-color: #000000;
          }

          #backlight {
              background-color: #90b1b1;
          }

          #network {
              background-color: #2980b9;
          }

          #network.disconnected {
              background-color: #f53c3c;
          }
        '';
        "wlogout/layout".text = ''
          {
              "label" : "lock",
              "action" : "hyprlock",
              "text" : "Lock",
              "keybind" : "l"
          }
          {
              "label" : "logout",
              "action" : "killall -9 Hyprland",
              "text" : "Exit",
              "keybind" : "e"
          }
          {
              "label" : "shutdown",
              "action" : "poweroff",
              "text" : "Shutdown",
              "keybind" : "s"
          }
          {
              "label" : "reboot",
              "action" : "reboot",
              "text" : "Reboot",
              "keybind" : "r"
          }
        '';
        "wlogout/style.css".text = ''
          /*
                    _                         _
          __      _| | ___   __ _  ___  _   _| |_
          \ \ /\ / / |/ _ \ / _` |/ _ \| | | | __|
           \ V  V /| | (_) | (_| | (_) | |_| | |_
            \_/\_/ |_|\___/ \__, |\___/ \__,_|\__|
                            |___/

          by Stephan Raabe (2024)
          -----------------------------------------------------
          */

          * {
            font-family: "Fira Sans Semibold", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
            background-image: none;
            transition: 20ms;
            box-shadow: none;
          }

          window {
            background-color: rgba(12, 12, 12, 0.8);
          }

          button {
            color: #FFFFFF;
            font-size:20px;
            background-repeat: no-repeat;
            background-position: center;
            background-size: 25%;
            border-style: solid;
            border: 3px solid #FFFFFF;
            box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
          }

          button:focus,
          button:active,
          button:hover {
            color: #FFFFFF;
            border: 3px solid #FFFFFF;
          }

          /*
          -----------------------------------------------------
          Buttons
          -----------------------------------------------------
          */

          #lock {
            margin: 10px;
            border-radius: 20px;
            background-image: image(url("icons/lock.png"));
          }

          #logout {
            margin: 10px;
            border-radius: 20px;
            background-image: image(url("icons/logout.png"));
          }

          #shutdown {
            margin: 10px;
            border-radius: 20px;
            background-image: image(url("icons/shutdown.png"));
          }

          #reboot {
            margin: 10px;
            border-radius: 20px;
            background-image: image(url("icons/reboot.png"));
          }
        '';
        "wlogout/icons/hibernate.png".source = "${ml4w_repo}/dotfiles/.config/wlogout/icons/hibernate.png";
        "wlogout/icons/lock.png".source = "${ml4w_repo}/dotfiles/.config/wlogout/icons/lock.png";
        "wlogout/icons/logout.png".source = "${ml4w_repo}/dotfiles/.config/wlogout/icons/logout.png";
        "wlogout/icons/reboot.png".source = "${ml4w_repo}/dotfiles/.config/wlogout/icons/reboot.png";
        "wlogout/icons/shutdown.png".source = "${ml4w_repo}/dotfiles/.config/wlogout/icons/shutdown.png";
        "wlogout/icons/suspend.png".source = "${ml4w_repo}/dotfiles/.config/wlogout/icons/suspend.png";
      };
  };
}
