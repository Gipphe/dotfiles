{
  config,
  util,
  pkgs,
  ...
}:
let
  steam = config.programs.steam.package;
in
util.mkProgram {
  name = "sunshine";
  nixos = {
    services.sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
      openFirewall = true;
      # Let right alt act as super for Nvidia SHIELD.
      settings.key_rightalt_to_key_win = true;
      applications = {
        env = {
          PATH = "$(PATH):$(HOME)/.local/bin";
        };
        apps = [
          {
            name = "Desktop";
            image-path = "desktop.png";
          }
          {
            name = "Steam Big Picture";
            detached = [
              "${pkgs.util-linux.bin}/bin/setsid ${steam}/bin/steam steam://open/bigpicture"
            ];
            prep-cmd = [
              {
                do = "";
                undo = "${pkgs.util-linux.bin}/bin/setsid ${steam}/bin/steam steam://close/bigpicture";
              }
            ];
            image-path = "steam.png";
          }
        ];
      };
    };
  };
}
