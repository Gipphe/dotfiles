{
  den.aspects.programs.imagemagick.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.imagemagick ];
  };
}
