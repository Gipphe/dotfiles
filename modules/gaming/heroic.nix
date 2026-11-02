{
  den.aspects.gaming.heroic.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.heroic ];
    };
}
