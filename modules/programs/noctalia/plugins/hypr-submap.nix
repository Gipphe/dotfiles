{
  inputs,
  util,
  pkgs,
  ...
}:
util.mkToggledModule [ "programs" "noctalia" "plugins" ] {
  name = "hypr-submap";
  homeManager = {
    programs.noctalia.settings.plugins.enabled = [ "k4n4t4/hypr-submap" ];
    home.packages = [
      pkgs.socat
      pkgs.coreutils
    ];
    xdg.dataFile."noctalia/plugins/hypr-submap".source =
      "${inputs.noctalia-community-plugins}/hypr-submap";
  };
}
