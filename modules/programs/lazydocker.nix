{
  den.aspects.programs.lazydocker.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.lazydocker ];
  };
}
