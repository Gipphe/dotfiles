{ lib, config, ... }:
{
  options.gipphe.machines."VNB-MB-Pro".enable = lib.mkEnableOption "VNB-MB-Pro machine config" // {
    default = config.gipphe.machine == "VNB-MB-Pro";
  };
  config = lib.mkIf config.gipphe.machines."VNB-MB-Pro".enable {
    gipphe = {
      username = "victor";
      homeDirectory = "/Users/victor";
      profiles = {
        core.enable = true;
        # desktop.enable = true;
        # darwin.enable = true;
        # logitech.enable = true;
        # kvm.enable = true;
        # work.enable = true;
      };
    };
    networking.hostName = "VNB-MB-Pro";
  };
}
