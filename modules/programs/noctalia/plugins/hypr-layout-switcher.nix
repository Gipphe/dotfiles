{ util, pkgs, ... }:
let
  sources = pkgs.callPackage ./sources.nix { };
in
util.mkToggledModule [ "programs" "noctalia" "plugins" ] {
  name = "hypr-layout-switcher";
  homeManager = {
    programs.noctalia.settings.plugins = {
      enabled = [ "maddingo/hypr-layout-switcher" ];
    };
    xdg.stateFile."noctalia/plugins/materialized/community/hypr-layout-switcher".source =
      "${sources.community}/hypr-layout-switcher";
  };
}
