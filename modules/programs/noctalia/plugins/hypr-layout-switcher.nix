{ inputs, util, ... }:
util.mkToggledModule [ "programs" "noctalia" "plugins" ] {
  name = "hypr-layout-switcher";
  homeManager = {
    programs.noctalia.settings.plugins.enabled = [ "maddingo/hypr-layout-switcher" ];
    xdg.dataFile."noctalia/plugins/hypr-layout-switcher".source =
      "${inputs.noctalia-community-plugins}/hypr-layout-switcher";
  };
}
