{ config, util, ... }:
util.mkProgram {
  name = "sddm";
  system-nixos.services.displayManager = {
    sddm = {
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
    };
    # autoLogin = {
    #   enable = true;
    #   user = config.gipphe.username;
    # };
  };
}
