{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.nix.gc.enable {
    programs.nh.clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 5d";
    };

    nix.gc = lib.mkIf (!config.gipphe.programs.nh.enable) {
      automatic = true;
      options = "--delete-older-than 10d";
      dates = "daily";
    };
  };
}
