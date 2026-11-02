{
  den.aspects.programs.memcached.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.memcached ];
  };
}
