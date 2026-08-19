{ util, pkgs, ... }:
let
  sources = pkgs.callPackage ./sources.nix { };
in
util.mkToggledModule [ "programs" "noctalia" "plugins" ] {
  name = "hypr-submap";
  homeManager = {
    programs.noctalia.settings.plugins.enabled = [ "k4n4t4/hypr-submap" ];
    home.packages = [
      pkgs.socat
      pkgs.coreutils
    ];
    xdg.stateFile."noctalia/plugins/materialized/community/hypr-submap".source =
      "${sources.community}/hypr-submap";
  };
}
