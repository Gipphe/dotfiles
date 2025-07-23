{ util, ... }:
util.mkProfile "multi-monitor" {
  gipphe.programs.kanshi.enable = true;
}
