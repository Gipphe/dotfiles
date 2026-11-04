{
  den.aspects.programs.mpris.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.playerctl ];
    services = {
      mpris-proxy.enable = true;
      playerctld.enable = true;
    };
  };
}
