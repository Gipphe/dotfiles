{
  den.aspects.programs.procs.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.procs ];
  };
}
