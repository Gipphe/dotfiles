{
  inputs,
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
    imports = [ inputs.lovdata.homeModules.mattermost ];
    config = {
      lovdata.mattermost.enable = true;
      gipphe.core.wm.binds = [
        {
          mod = "$mod";
          key = "M";
          action.spawn = "${lib.getExe pkg}";
        }
      ];
    };
  };
}
