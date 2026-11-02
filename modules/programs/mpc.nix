{
  den.aspects.programs.mpc.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.mpc ];
  };
}
