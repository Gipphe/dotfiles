{ lib, config, ... }:
{
  config = lib.mkIf (config.gipphe.machine == "Jarle") {
    gipphe = {
      username = "gipphe";
      homeDirectory = "/home/gipphe";
      profiles = {
        core = {
          enable = true;
          systemd.enable = true;
        };
        desktop = {
          work.enable = true;
        };
        libraries.fonts.enable = true;
        system.nixos.enable = true;
        system.nixos.wsl.enable = true;
        secrets.enable = true;
        virtualization.vm-guest.enable = true;
        virtualization.containers.enable = true;

        user = {
          username = "gipphe";
          homeDirectory = "/home/gipphe";
        };
      };
    };

    networking.hostname = "Jarle";
  };
}
