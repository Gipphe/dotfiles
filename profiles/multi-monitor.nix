{ util, ... }:
util.mkProfile {
  name = "multi-monitor";
  shared.gipphe.programs.kanshi.enable = true;
}
