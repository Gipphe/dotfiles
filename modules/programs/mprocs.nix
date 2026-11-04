{
  den.aspects.programs.mprocs.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.mprocs ];
  };
}
