{ util, pkgs, ... }:
util.mkProgram {
  name = "moonlight-qt";
  home-manager.home.packages = [ pkgs.moonlight-qt ];
}
