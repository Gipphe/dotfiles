{
  inputs,
  util,
  pkgs,
  ...
}:
util.mkToggledModule [ "programs" "noctalia" "plugins" ] {
  name = "special-workspaces";
  homeManager = {
    programs.noctalia.settings.plugins.enabled = [ "jamesfeeder/special-workspaces" ];
    home.packages = [ pkgs.socat ];
    xdg.dataFile."noctalia/plugins/special-workspaces".source =
      "${inputs.noctalia-community-plugins}/special-workspaces";
  };
}
