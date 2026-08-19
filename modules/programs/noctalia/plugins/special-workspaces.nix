{ util, pkgs, ... }:
let
  sources = pkgs.callPackage ./sources.nix { };
in
util.mkToggledModule [ "programs" "noctalia" "plugins" ] {
  name = "special-workspaces";
  homeManager = {
    programs.noctalia.settings.plugins.enabled = [ "jamesfeeder/special-workspaces" ];
    home.packages = [ pkgs.socat ];
    xdg.stateFile."noctalia/plugins/materialized/community/special-workspaces".source =
      "${sources.community}/special-workspaces";
  };
}
