{ config, util, ... }:
util.mkEnvironment {
  name = "display";
  system-nixos = {
    services = {
      displayManager = {
        sddm = {
          enable = true;
          autoNumlock = true;
        };
        # Enable automatic login for the user.
        autoLogin = {
          enable = true;
          user = config.gipphe.username;
        };
      };
    };
  };
}
