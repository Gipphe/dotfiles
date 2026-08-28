{ inputs, util, ... }:
util.mkToggledModule [ "programs" "noctalia" "plugins" ] {
  name = "hypr-layout-switcher";
  homeManager = {
    programs.noctalia.settings = {
      plugins.enabled = [ "maddingo/hypr-layout-switcher" ];
      widget.toggle.type = "maddingo/hypr-layout-switcher:toggle";
    };
    xdg.dataFile."noctalia/plugins/hypr-layout-switcher".source =
      "${inputs.noctalia-community-plugins}/hypr-layout-switcher";
  };
}
