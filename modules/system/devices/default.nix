{ util, ... }:
util.mkSystem {
  name = "devices";
  system-nixos = {
    services.seatd.enable = true;
  };
}
