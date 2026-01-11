{
  util,
  pkgs,
  config,
  ...
}:
let
  colors = config.lib.stylix.colors.withHashtag;
in
util.mkProgram {
  name = "waybar";
  hm = {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings.mainBar = {
        layer = "top";
        position = "top";
        spacing = 10;
        height = 43;

        # Match eww bar layout: left (app-drawer, workspaces, window-title), center (empty), right (modules)
        modules-left = [
          "custom/appmenu"
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ ];
        modules-right = [
          "cpu"
          "temperature"
          "memory"
          "custom/separator"
          "backlight"
          "pulseaudio"
          "network"
          "battery"
          "custom/separator2"
          "tray"
          "custom/separator3"
          "custom/notifications"
          "clock"
        ];

        # Workspaces - equivalent to eww workspaces module
        "hyprland/workspaces" = {
          on-click = "activate";
          active-only = false;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
          };
        };

        # Window title - equivalent to eww window-title module
        "hyprland/window" = {
          rewrite = {
            "(.*) - Brave" = "$1";
            "(.*) - Chromium" = "$1";
            "(.*) - Brave Search" = "$1";
            "(.*) - Outlook" = "$1";
            "(.*) Microsoft Teams" = "$1";
            "Zellij \\((?:.*)\\) - (.*)" = "$1";
          };
          separate-outputs = true;
        };

        # App Drawer - equivalent to eww app-drawer (launches walker)
        "custom/appmenu" = {
          format = "󱗼";
          tooltip = false;
          on-click = "${pkgs.walker}/bin/walker";
        };

        # CPU - equivalent to eww cpu module
        cpu = {
          interval = 2;
          format = " {usage}%";
          tooltip = false;
        };

        # Temperature - equivalent to eww temp module
        temperature = {
          interval = 10;
          thermal-zone = 0;
          format = "{icon} {temperatureC}°C";
          format-icons = [
            "󱃃" # < 60°C - cool
            "󰔏" # 60-69°C - moderate
            "󱃂" # 70-79°C - warm
            "󰸁" # >= 80°C - hot
          ];
          tooltip-format = "{temperatureC}°C";
        };

        # Memory - equivalent to eww memory module
        memory = {
          interval = 15;
          format = " {percentage}%";
          tooltip-format = "{used:0.1f}G / {total:0.1f}G used";
        };

        # Backlight/Brightness - equivalent to eww brightness module
        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = [ "󰛨" ]; # Single icon for all brightness levels
          tooltip = false;
        };

        # Pulseaudio/Volume - equivalent to eww volume module
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " {volume}%";
          format-icons = {
            default = [
              "" # 0%
              "" # 1-50%
              "" # > 50%
            ];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          tooltip-format = "{desc}";
        };

        # Network - equivalent to eww network module
        network = {
          interval = 5;
          format-wifi = "  {signalStrength}%";
          format-ethernet = "󰈁 {ipaddr}";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format-disconnected = "Disconnected";
          on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
        };

        # Battery - equivalent to eww battery module
        battery = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰂄 {capacity}%";
          format-icons = [
            "󰂃" # 0-9%
            "󰁺" # 10-19%
            "󰁻" # 20-29%
            "󰁼" # 30-39%
            "󰁽" # 40-49%
            "󰁾" # 50-59%
            "󰁿" # 60-69%
            "󰂀" # 70-79%
            "󰂁" # 80-89%
            "󰂂" # 90-99%
            "󰁹" # 100%
          ];
          tooltip-format = "{timeTo}, {capacity}%";
        };

        # System tray - equivalent to eww tray module
        tray = {
          spacing = 10;
        };

        # Notifications - equivalent to eww notifications module (uses swaync)
        "custom/notifications" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "󱏧";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "󱏧";
          };
          return-type = "json";
          exec-if = "which ${pkgs.swaynotificationcenter}/bin/swaync-client";
          exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
          on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
          on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
          escape = true;
        };

        # Clock - equivalent to eww time module
        clock = {
          interval = 60;
          format = "{:%H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        # Separators - equivalent to eww sep widget
        "custom/separator" = {
          format = "|";
          tooltip = false;
        };
        "custom/separator2" = {
          format = "|";
          tooltip = false;
        };
        "custom/separator3" = {
          format = "|";
          tooltip = false;
        };
      };

      # Style matching eww bar appearance
      style = /* css */ ''
        @define-color base00 ${colors.base00};
        @define-color base01 ${colors.base01};
        @define-color base02 ${colors.base02};
        @define-color base03 ${colors.base03};
        @define-color base04 ${colors.base04};
        @define-color base05 ${colors.base05};
        @define-color base0D ${colors.base0D};

        * {
          font-family: "Fira Sans", "Font Awesome 6 Free", sans-serif;
          font-size: 14px;
          font-weight: 600;
          border: none;
          border-radius: 0;
          min-height: 0;
        }

        window#waybar {
          background-color: transparent;
        }

        #workspaces,
        #window,
        #custom-appmenu,
        #cpu,
        #temperature,
        #memory,
        #backlight,
        #pulseaudio,
        #network,
        #battery,
        #tray,
        #custom-notifications,
        #clock {
          padding: 8px 12px;
          margin: 5px 0;
          background-color: @base01;
          color: @base05;
          border-radius: 8px;
        }

        #custom-separator,
        #custom-separator2,
        #custom-separator3 {
          padding: 0 5px;
          margin: 0;
          background-color: transparent;
          color: @base04;
        }

        #workspaces {
          padding: 0;
          margin-right: 10px;
        }

        #workspaces button {
          padding: 8px 12px;
          margin: 0 2px;
          background-color: transparent;
          color: @base04;
          border-radius: 8px;
          transition: all 0.3s ease;
        }

        #workspaces button.active {
          background-color: @base0D;
          color: @base00;
        }

        #workspaces button:hover {
          background-color: @base02;
          color: @base05;
        }

        #custom-appmenu {
          font-size: 18px;
          padding: 8px 14px;
        }

        #cpu {
          color: @base0D;
        }

        #temperature {
          color: @base05;
        }

        #memory {
          color: @base0D;
        }

        #backlight {
          color: @base05;
        }

        #pulseaudio {
          color: @base05;
        }

        #pulseaudio.muted {
          color: @base04;
        }

        #network {
          color: @base05;
        }

        #network.disconnected {
          color: @base04;
        }

        #battery {
          color: @base05;
        }

        #battery.charging,
        #battery.plugged {
          color: @base0D;
        }

        #battery.warning:not(.charging) {
          color: #f9e2af;
        }

        #battery.critical:not(.charging) {
          color: #f38ba8;
          animation: blink 1s ease-in-out infinite;
        }

        @keyframes blink {
          50% {
            opacity: 0.5;
          }
        }

        #clock {
          margin-right: 10px;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
        }
      '';
    };
  };
}
