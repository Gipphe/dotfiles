{ util, ... }:
util.mkProfile {
  name = "vm-guest";
  shared.gipphe.virtualisation.virtualbox-guest.enable = true;
}
