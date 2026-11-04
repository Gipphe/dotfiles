{
  den.aspects.programs.gimp.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.gimp-with-plugins ];
  };
}
