{
  util,
  config,
  pkgs,
  ...
}:
let
  hyprlock = "${config.programs.hyprlock.package}/bin/hyprlock";
  killall = "${pkgs.killall}/bin/killall";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  icons = import ./icons { inherit pkgs; };
  colors = config.lib.stylix.colors.withHashtag;
  raw_colors = config.lib.stylix.colors;
in
util.mkProgram {
  name = "wlogout";
  hm.programs.wlogout = {
    enable = true;
    layout = [
      {
        "label" = "lock";
        "action" = hyprlock;
        "text" = "Lock";
        "keybind" = "l";
      }
      {
        "label" = "logout";
        "action" = "${killall} -9 Hyprland";
        "text" = "Log out";
        "keybind" = "e";
      }
      {
        "label" = "shutdown";
        "action" = "${systemctl} poweroff";
        "text" = "Shut down";
        "keybind" = "s";
      }
      {
        "label" = "reboot";
        "action" = "${systemctl} reboot";
        "text" = "Reboot";
        "keybind" = "r";
      }
    ];
    style = ''
      * {
        font-family: "Fira Sans Semibold", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
        background-image: none;
        transition: 20ms;
        box-shadow: none;
      }

      window {
        background-color: rgba(${raw_colors.base01-rgb-r}, ${raw_colors.base01-rgb-g}, ${raw_colors.base01-rgb-b}, 0.8);
      }

      button {
        color: ${colors.bright-cyan};
        font-size: 20px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        border-style: solid;
        border: 3px solid ${colors.bright-cyan};
        box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
      }

      button:focus,
      button:active,
      button:hover {
        color: ${colors.bright-cyan};
        border: 3px solid ${colors.bright-cyan};
      }

      button:hover {
        cursor: pointer;
      }

      /*
      -----------------------------------------------------
      Buttons
      -----------------------------------------------------
      */

      #lock {
        margin: 10px;
        border-radius: 20px;
        background-image: image(url("${icons}/actions/24/lock.svg"));
      }

      #logout {
        margin: 10px;
        border-radius: 20px;
        background-image: image(url("${icons}/actions/24/application-exit.svg"));
      }

      #shutdown {
        margin: 10px;
        border-radius: 20px;
        background-image: image(url("${icons}/actions/view-close.svg"));
      }

      #reboot {
        margin: 10px;
        border-radius: 20px;
        background-image: image(url("${icons}/actions/view-refresh.svg"));
      }
    '';
  };
}
