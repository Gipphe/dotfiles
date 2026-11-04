{ inputs, ... }:
{
  den.aspects.programs.noctalia.plugins.special-workspaces.homeManager = { pkgs, ... }: {
    programs.noctalia.settings = {
      plugins.enabled = [ "jamesfeeder/special-workspaces" ];
      widget.special-workspaces.type = "jamesfeeder/special-workspaces:special-workspaces";
    };
    home.packages = [ pkgs.socat ];
    xdg.dataFile."noctalia/plugins/special-workspaces".source =
      "${inputs.noctalia-community-plugins}/special-workspaces";
  };
}
