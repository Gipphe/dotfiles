{
  den.aspects.programs.libgcc.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.libgcc ];
  };
}
