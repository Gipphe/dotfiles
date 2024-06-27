{ lib, config, ... }:
{
  config = lib.mkIf (config.gipphe.machine == "Jarle") {
    gipphe = {
      username = "gipphe";
      homeDirectory = "/home/gipphe";
      profiles = {
        containers.enable = true;
        core.enable = true;
        fonts.enable = true;
        nixos = {
          system.enable = true;
          wsl.enable = true;
        };
        rice.enable = true;
        secrets.enable = true;
        systemd.enable = true;
        vm-guest.enable = true;
        work.enable = true;
      };
    };

    networking.hostName = "Jarle";
  };
}
