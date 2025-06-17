{ util, ... }:
util.mkProgram {
  name = "pay-respects";
  hm.programs.pay-respects.enable = true;
}
