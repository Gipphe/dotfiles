{ util, ... }:
util.mkToggledModule [ "hardware" ] {
  name = "disk";
  nixos = {
    services.udisks2.enable = true;
  };
}
