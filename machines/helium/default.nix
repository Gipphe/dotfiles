{ lib, util, ... }:
util.mkToggledModule [ "machines" ] {
  name = "helium";
  shared = {
    gipphe = {
      username = "nix-on-droid";
      homeDirectory = "/data/data/com.termux.nix/files/home";
      hostName = "helium";
      profiles = {
        cli.enable = true;
        core.enable = true;
        fonts.enable = true;
        gc.enable = true;
        rice.enable = false;
        secrets.enable = false;
      };
    };
  };
  system-droid.system.stateVersion = "24.05";
}
