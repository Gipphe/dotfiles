{
  util,
  pkgs,
  config,
  ...
}:
let
  colors = config.lib.stylix.colors.withHashtag;
  restart-waybar = pkgs.writeShellScriptBin "restart-waybar" ''
    ${pkgs.killall}/bin/killall waybar
    sleep 1s
    ${config.programs.waybar.package}/bin/waybar
  '';
in
util.mkToggledModule [ "environment" "desktop" "hyprland" ] {
  name = "waybar";
  hm = {
    home.packages = [
      restart-waybar
    ];
    programs.waybar = {
      enable = true;
      settings.mainBar = {
        "layer" = "top"; # Waybar at top layer
        "position" = "top"; # Waybar position (top|bottom|left|right)
        "height" = 30; # Waybar height (to be removed for auto height)
        # "width"= 1280, // Waybar width
        "spacing" = 4; # Gaps between modules (4px)
        # Choose the order of the modules

        "modules-left" = [
          "custom/appmenu"
          "group/quicklinks"
          "hyprland/window"
        ];
        "modules-center" = [
          "hyprland/workspaces"
        ];
        "modules-right" = [
          "mpd"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "keyboard-state"
          "battery"
          "clock"
          "tray"
          "custom/exit"
        ];

        # Modules

        # Workspaces
        "hyprland/workspaces" = {
          on-click = "activate";
          active-only = false;
          all-outputs = true;
          format = "{}";
          format-icons = {
            urgent = "";
            active = "";
            default = "";
          };
          persistent-workspaces = {
            "*" = 2;
          };
        };

        # Hyprland Window
        "hyprland/window" = {
          rewrite = {
            "(.*) - Brave" = "$1";
            "(.*) - Chromium" = "$1";
            "(.*) - Brave Search" = "$1";
            "(.*) - Outlook" = "$1";
            "(.*) Microsoft Teams" = "$1";
          };
          separate-outputs = true;
        };

        # Rofi Application Launcher
        "custom/appmenu" = {
          format = "Apps";
          tooltip-format = "Left: Open the application launcher\nRight: Show all keybindings";
          on-click = "rofi -show drun -replace";
          on-click-right = "~/.config/ml4w/scripts/keybindings.sh";
          tooltip = false;
        };

        # Power Menu
        "custom/exit" = {
          format = "";
          tooltip-format = "Powermenu";
          on-click = "wlogout -b 4";
          tooltip = false;
        };

        # Keyboard State
        keyboard-state = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };

        # System tray
        tray = {
          # icon-size= 21;
          spacing = 10;
        };

        # Clock
        clock = {
          # timezone= "America/New_York";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        # System
        "custom/system" = {
          format = "";
          tooltip = false;
        };

        # CPU
        cpu = {
          format = "/ C {usage}% ";
          on-click = "alacritty -e htop";
        };

        # Memory
        memory = {
          format = "/ M {}% ";
          on-click = "alacritty -e htop";
        };

        # Harddisc space used
        disk = {
          interval = 30;
          format = "D {percentage_used}% ";
          path = "/";
          on-click = "alacritty -e htop";
        };

        "hyprland/language" = {
          format = "/ K {short}";
        };

        # Group Hardware
        "group/hardware" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 300;
            children-class = "not-memory";
            transition-left-to-right = false;
          };
          modules = [
            "custom/system"
            "disk"
            "cpu"
            "memory"
            "hyprland/language"
          ];
        };

        # Network
        network = {
          format = "{ifname}";
          format-wifi = "   {signalStrength}%";
          format-ethernet = "  {ipaddr}";
          format-disconnected = "Not connected"; # An empty format will hide the module.
          tooltip-format = " {ifname} via {gwaddri}";
          tooltip-format-wifi = "   {essid} ({signalStrength}%)";
          tooltip-format-ethernet = "  {ifname} ({ipaddr}/{cidr})";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
          on-click = "alacritty -e nmtui";
        };

        # Battery
        battery = {
          states = {
            # good= 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon}   {capacity}%";
          format-charging = "  {capacity}%";
          format-plugged = "  {capacity}%";
          format-alt = "{icon}  {time}";
          # format-good= ""; // An empty format will hide the module
          # format-full= "";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
          ];
        };

        # Pulseaudio
        pulseaudio = {
          # "scroll-step"= 1; // %, can be a float
          format = "{icon}  {volume}%";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              " "
              " "
            ];
          };
          on-click = "pavucontrol";
        };

        # Bluetooth
        bluetooth = {
          format-disabled = "";
          format-off = "";
          interval = 30;
          on-click = "blueman-manager";
          format-no-controller = "";
        };

        # Other
        user = {
          format = "{user}";
          interval = 60;
          icon = false;
        };

        # Idle Inhibator
        idle_inhibitor = {
          format = "{icon}";
          tooltip = true;
          format-icons = {
            activated = "";
            deactivated = "";
          };
          on-click-right = "hyprlock";
        };

        "custom/quicklink1" = {
          format = " ";
          on-click = "~/.config/ml4w/apps/ML4W_Hyprland_Settings-x86_64.AppImage";
          tooltip-format = "Open Hyprland Settings";
        };
        "custom/quicklink2" = {
          format = " ";
          on-click = "~/.config/ml4w/settings/browser.sh";
          tooltip-format = "Open the browser";
        };
        "custom/quicklink3" = {
          format = " ";
          on-click = "~/.config/ml4w/settings/filemanager.sh";
          tooltip-format = "Open the filemanager";
        };
        "custom/quicklinkempty" = { };
        "group/quicklinks" = {
          orientation = "horizontal";
          modules = [
            "custom/quicklink1"
            "custom/quicklink2"
            "custom/quicklink3"
            "custom/quicklinkempty"
          ];
        };
      };
      style = ''
        @define-color backgroundlight ${colors.base04};
        @define-color backgrounddark ${colors.base00};
        @define-color workspacesbackground1 ${colors.base01};
        @define-color workspacesbackground2 ${colors.base03};
        @define-color bordercolor ${colors.base0D};
        @define-color textcolor1 #000000;
        @define-color textcolor2 #000000;
        @define-color textcolor3 ${colors.base05};
        @define-color iconcolor ${colors.base05};

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
    };
    wayland.windowManager.hyprland.settings.exec-once = [
      "${config.programs.waybar.package}/bin/waybar"
    ];
  };
}
