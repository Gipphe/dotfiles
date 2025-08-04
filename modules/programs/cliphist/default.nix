{ util, ... }:
util.mkProgram {
  name = "cliphist";
  hm.services.cliphist = {
    enable = true;
  };
}
