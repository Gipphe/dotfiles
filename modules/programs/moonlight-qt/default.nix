{ util, pkgs, ... }:
util.mkProgram {
  name = "moonlight-qt";
  homeManager.home.packages = [ pkgs.moonlight-qt ];
}
