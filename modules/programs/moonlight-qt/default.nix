{ util, pkgs, ... }:
util.mkProgram {
  name = "moonlight-qt";
  hm.home.packages = [ pkgs.moonlight-qt ];
}
