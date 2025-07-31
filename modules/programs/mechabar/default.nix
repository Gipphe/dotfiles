{
  util,
  pkgs,
  lib,
  config,
  ...
}:
let
  mechabar = pkgs.fetchFromGitHub {
    owner = "sejjy";
    repo = "mechabar";
    rev = "classic";
    hash = "sha256-0XfC9vAjzHwEUli0JjVAdA5leHIqDxExzA8yNWRq6YM=";
  };
  kill-waybar = ''
    ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
  '';
  swaync = "${config.gipphe.environment.desktop.hyprland.swaync.package}/bin/swaync-client";
in
util.mkProgram {
  name = "mechabar";
  hm = {
    xdg.configFile = {
      "waybar/config.jsonc" = {
        source = pkgs.runCommandNoCC "waybar-config" { } ''
          export PATH=${
            lib.makeBinPath [
              pkgs.coreutils
              pkgs.gnused
            ]
          }:$PATH

          notifications='{
            "tooltip": false,
            "format": "{icon}",
            "format-icons": {
              "notification": "<span foreground='red'><sup></sup></span>",
              "none": "",
              "dnd-notification": "<span foreground='red'><sup></sup></span>",
              "dnd-none": "",
              "inhibited-notification": "<span foreground='red'><sup></sup></span>",
              "inhibited-none": "",
              "dnd-inhibited-notification": "<span foreground='red'><sup></sup></span>",
              "dnd-inhibited-none": ""
            },
            "return-type": "json",
            "exec": "${swaync} -swb",
            "on-click": "${swaync} -t -sw",
            "on-click-right": "${swaync} -d -sw",
            "escape": true
          }'

          cat ${mechabar}/themes/jsonc/catppuccin-macchiato.jsonc |
          sed 's///g' |
          sed 's/%m-%d/%d-%m/g' |
          sed 's!"custom/left7",!"custom/notifications","tray","custom/left7",!' |
          head -n -1 |
          cat - <(echo ',"custom/notifications": '"$notifications }") |
          tee $out >/dev/null
        '';
        onChange = kill-waybar;
      };
      "waybar/style.css" = {
        source = pkgs.runCommandNoCC "waybar-style" { } ''
          cat "${mechabar}/style.css" "${./style.css}" > $out
        '';
        onChange = kill-waybar;
      };
      "waybar/theme.css" = {
        source = "${mechabar}/themes/css/catppuccin-macchiato.css";
        onChange = kill-waybar;
      };
      "waybar/scripts".source = pkgs.runCommandNoCC "waybar-scripts" { } ''
        cp -r "${mechabar}/scripts" "$out"
        chmod -R +x "$out"
      '';
      "rofi".source = "${mechabar}/rofi";
    };
    home.packages = with pkgs; [
      bluez-tools
      brightnessctl
      pacman
      nerd-fonts.jetbrains-mono
      wireplumber
      gnused
      coreutils
      networkmanager
      gawk
      bluetui
      lm_sensors
      # Alternative to AUR package rofi-lbonn-wayland-git
      rofi-wayland
    ];
    programs.waybar = {
      enable = true;
      settings = [ ];
      style = lib.mkForce null;
      systemd.enable = true;
    };
  };
}
