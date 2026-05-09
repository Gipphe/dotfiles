{ util, ... }:
util.mkProgram {
  name = "kanshi";
  home-manager.services.kanshi = {
    enable = true;
  };
}
