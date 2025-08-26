{
  util,
  pkgs,
  lib,
  ...
}:
let
  pkg = pkgs.mattermost-desktop;
in
util.mkProgram {
  name = "mattermost";
  hm = {
    home.packages = [ pkgs.mattermost-desktop ];
    gipphe.core.wm.binds = [
      {
        mod = "$mod";
        key = "M";
        action.spawn = "${lib.getExe pkg}";
      }
    ];
  };
}
