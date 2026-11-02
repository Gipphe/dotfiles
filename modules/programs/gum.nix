{
  den.aspects.programs.gum.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.gum ];
  };
}
