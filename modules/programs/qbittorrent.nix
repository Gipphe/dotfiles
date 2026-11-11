{
  den.aspects.programs.qbittorrent.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.qbittorrent ];
  };
}
