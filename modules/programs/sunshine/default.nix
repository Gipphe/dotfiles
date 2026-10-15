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
