{ lib, config, ... }:
{
  config = lib.mkIf (config.gipphe.machine == "VNB-MB-Pro") {
    gipphe.profiles = {
      core = {
        enable = true;
        # audio.enable = true;
      };
      # desktop = {
      #   enable = true;
      #   darwin = {
      #     enable = true;
      #     logitech.enable = true;
      #   };
      #   kvm.enable = true;
      #   work.enable = true;
      # };
    };
  };
}
