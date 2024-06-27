{ lib, config, ... }:
{
  config = lib.mkIf (config.gipphe.machine == "VNB-MB-Pro") {
    gipphe = {
      username = "victor";
      homeDirectory = "/Users/victor";
      profiles = {
        core = {
          enable = true;
        };
        desktop = {
          enable = true;
          darwin = {
            enable = true;
            logitech.enable = true;
          };
          kvm.enable = true;
          work.enable = true;
        };
      };
    };
    networking.hostname = "VNB-MB-Pro";
  };
}
