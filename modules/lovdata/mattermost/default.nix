{
  util,
  pkgs,
  lib,
  ...
}:
let
  pkg = pkgs.mattermost-desktop;
in
util.mkToggledModule [ "lovdata" ] {
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
