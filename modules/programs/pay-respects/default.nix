{ util, ... }:
util.mkProgram {
  name = "pay-respects";
  homeManager.programs.pay-respects.enable = true;
}
