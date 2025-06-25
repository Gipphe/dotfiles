{ util, pkgs, ... }:
util.mkProgram {
  name = "mattermost";
  hm.home.packages = [ pkgs.mattermost-desktop ];
}
