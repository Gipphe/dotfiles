{
  den.aspects.programs.pinentry-curses.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.pinentry-curses ];
  };
}
