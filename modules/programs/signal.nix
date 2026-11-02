{
  den.aspects.programs.signal.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.signal-desktop ];
  };
}
