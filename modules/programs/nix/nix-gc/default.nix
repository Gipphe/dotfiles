{
  lib,
  config,
  util,
  ...
}:
util.mkModule {
  options.gipphe.programs.nix.gc.enable = lib.mkEnableOption "nix.gc";
  system-nixos = lib.mkIf config.gipphe.programs.nix.gc.enable {
    programs.nh.clean = {
      enable = true;
      extraArgs = "--nogcroots --keep 3 --keep-since 8d";
      dates = "weekly";
    };

    nix.gc = lib.mkIf (!config.gipphe.programs.nh.enable) {
      automatic = true;
      options = "--delete-older-than 8d";
      dates = "weekly";
    };
  };
}
