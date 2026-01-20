{ util, ... }:
util.mkProgram {
  name = "soteria";
  system-nixos = {
    security.soteria.enable = true;
  };
}
