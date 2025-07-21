{
  util,
  pkgs,
  config,
  ...
}:
let
  vpn = "${config.gipphe.programs.openconnect.openconnect-lovdata}/bin/openconnect-lovdata";
  nm-connection-editor = "${config.gipphe.programs.networkmanagerapplet.package}/bin/nm-connection-editor";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  walker = "${config.gipphe.environment.desktop.hyprland.walker.package}/bin/walker";
  hyprlock = "${config.gipphe.environment.desktop.hyprland.hyprlock.package}/bin/hyprlock";
in
util.mkToggledModule [ "environment" "desktop" "hyprland" ] {
  name = "ashell";
  hm = {
    programs.ashell = {
      enable = true;
      systemd.enable = true;
      settings = {
        app_launcher_cmd = "${walker} --modules applications";
        clipboard_cmd = "${walker} --modules clipboard";
        keyboard_layout.labels = {
          "Norwegian" = "🇳🇴";
          "English (US)" = "🇺🇸";
        };
        clock.format = "%a %F %R";

        CustomModule = [
          {
            name = "CustomNotifications";
            icon = "";
            command = "swaync-client -t -sw";
            listen_cmd = "swaync-client -swb";
            "icons.'dnd.*'" = "";
            alert = ".*notification";
          }
        ];

        modules = {
          left = [
            "Workspaces"
            "MediaPlayer"
          ];
          center = [ "WindowTitle" ];
          right = [
            "SystemInfo"
            [
              "Privacy"
              "Settings"
            ]
            "CustomNotifications"
            "Tray"
            "Clock"
          ];
        };

        settings = {
          lock_cmd = "${hyprlock} &";
          shutdown_cmd = "poweroff";
          suspend_cmd = "systemctl suspend";
          reboot_cmd = "systemctl reboot";
          logout_cmd = "loginctl kill-user $(whoami)";
          audio_sinks_more_cmd = "${pavucontrol} -t 3";
          audio_sources_more_cmd = "${pavucontrol} -t 4";
          wifi_more_cmd = nm-connection-editor;
          vpn_more_cmd = vpn;
          bluetooth_more_cmd = "${config.gipphe.system.bluetooth.blueman.package}/bin/blueman-manager";
        };

        appearance = {
          font_name = "Fira Code Nerd Font Mono";
        };
      };
    };
    # Disable automatic VPN connect with this bar
    gipphe.programs.openconnect.systemd = false;
  };
}
