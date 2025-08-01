{ util, ... }:
util.mkProfile {
  name = "vm-guest";
  shared.gipphe.programs.virtualbox-guest.enable = true;
}
