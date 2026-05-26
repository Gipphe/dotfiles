{ util, ... }:
util.mkProgram {
  name = "automatic-timezoned";
  nixos = {
    services.automatic-timezoned.enable = true;

    # Enable polkit for authorization (required by automatic-timezoned)
    security.polkit.enable = true;
  };
}
