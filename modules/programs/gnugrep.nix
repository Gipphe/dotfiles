{
  den.aspects.programs.gnugrep.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.gnugrep ];
  };
}
