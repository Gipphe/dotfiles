{
  lib,
  config,
  util,
  ...
}:
util.mkToggledModule [ "programs" "nix" ] {
  name = "gc";
  nixos = {
    programs.nh.clean = {
      enable = true;
      extraArgs = "--optimise --nogcroots --keep 3 --keep-since 8d";
      dates = "weekly";
    };

    nix.gc = lib.mkIf (!config.gipphe.programs.nh.enable) {
      automatic = true;
      options = "--delete-older-than 8d";
      dates = "weekly";
    };
  };
}
