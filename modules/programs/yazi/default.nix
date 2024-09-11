{ util, ... }:
util.mkProgram {
  name = "yazi";
  hm.programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };
}
