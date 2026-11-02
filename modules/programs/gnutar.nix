{
  den.aspects.programs.gnutar.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.gnutar ];
  };
}
