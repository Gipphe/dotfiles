{ util, ... }:
util.mkToggledModule [ "hardware" ] {
  name = "disk";
  system-nixos = {
    services.udisks2.enable = true;
  };
}
