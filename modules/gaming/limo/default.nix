{ util, pkgs, ... }:
util.mkGaming {
  name = "limo";
  homeManager = {
    home.packages = [
      (pkgs.limo.overrideAttrs {
        patches = pkgs.limo.patches ++ [ ./gcc16.patch ];
      })
    ];
  };
}
