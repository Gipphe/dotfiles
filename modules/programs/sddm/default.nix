{ config, util, ... }:
util.mkProgram {
  name = "sddm";
  system-nixos.services.displayManager = {
    sddm = {
      enable = true;
      autoNumlock = true;
    };
    autoLogin = {
      enable = true;
      user = config.gipphe.username;
    };
  };
}
