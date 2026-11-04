{ inputs, ... }:
{
  den.aspects.programs.noctalia.plugins.hypr-submap.homeManager = { pkgs, ... }: {
    programs.noctalia.settings = {
      plugins.enabled = [ "k4n4t4/hypr-submap" ];
      widget.hypr-submap = {
        hide_when_default = true;
        type = "k4n4t4/hypr-submap:hypr-submap";
      };
    };
    home.packages = [
      pkgs.socat
      pkgs.coreutils
    ];
    xdg.dataFile."noctalia/plugins/hypr-submap".source =
      "${inputs.noctalia-community-plugins}/hypr-submap";
  };
}
