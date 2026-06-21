{
  lib,
  pkgs,
  util,
  inputs,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.tricorder;
in
util.mkModule {
  shared.imports = [
    (util.mkProgram {
      name = "tricorder";
      homeManager = {
        options.gipphe.programs.tricorder = {
          package = lib.mkPackageOption pkgs "tricorder" { } // {
            default = inputs.tricorder.packages.${pkgs.stdenv.hostPlatform.system}.tricorder;
          };
        };
        config = {
          home.packages = [ cfg.package ];
        };
      };
    })
  ];
  nixos = {
    nix.settings.trusted-substituters = [
      "https://cache.iog.io"
      "https://atelier.cachix.org"
    ];
    nix.settings.trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "atelier.cachix.org-1:rEyd/Z4TiXZbBVuU/lDnKZ/7WtnFTwJ17OKHGcahVUo="
    ];
  };
}
