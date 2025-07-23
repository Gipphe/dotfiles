{ util, ... }:
util.mkProgram {
  name = "kanshi";
  hm.services.kanshi = {
    enable = true;
  };
}
