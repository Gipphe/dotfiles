{
  util,
  pkgs,
  lib,
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
in
util.mkToggledModule [ "environment" "desktop" "hyprland" ] {
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
          cat ${mechabar}/config.jsonc |
          sed 's///g' |
          sed 's/%m-%d/%d-%m/g' |
          sed 's!"custom/left7",!"tray","custom/left7",!' |
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
        source = "${mechabar}/theme.css";
        onChange = kill-waybar;
      };
      "waybar/themes" = {
        source = "${mechabar}/themes";
        onChange = kill-waybar;
      };
      "waybar/scripts".source = pkgs.runCommandNoCC "waybar-scripts" { } ''
        mkdir -p "$out"
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
      bluetui
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
