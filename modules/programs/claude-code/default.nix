{ util, pkgs, ... }:
util.mkProgram {
  name = "claude-code";
  hm.home.packages = [ pkgs.claude-code ];
}
