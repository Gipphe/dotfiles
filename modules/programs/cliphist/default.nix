{ util, ... }:
util.mkProgram {
  name = "cliphist";
  home-manager.services.cliphist = {
    enable = true;
  };
}
