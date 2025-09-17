{ util, ... }:
util.mkProfile {
  name = "time";
  shared.gipphe.programs.chrony.enable = true;
}
