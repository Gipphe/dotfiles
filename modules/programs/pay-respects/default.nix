{ util, ... }:
util.mkProgram {
  name = "pay-respects";
  home-manager.programs.pay-respects.enable = true;
}
