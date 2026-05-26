{ util, ... }:
util.mkProgram {
  name = "soteria";
  nixos = {
    security.soteria.enable = true;
  };
}
