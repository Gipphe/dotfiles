{ util, ... }:
util.mkProgram {
  name = "ly";
  nixos = {
    security.pam.services.ly = {
      enableGnomeKeyring = true;
    };
    services.displayManager = {
      enable = true;
      ly = {
        enable = true;
        x11Support = false;
        settings = {
          animation = "matrix";
        };
      };
    };
  };
}
