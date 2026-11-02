{ inputs, ... }:
{
  den.aspects.programs.tricorder = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ inputs.tricorder.packages.${pkgs.stdenv.hostPlatform.system}.tricorder ];
      };
    nixos = {
      nix.settings.trusted-substituters = [
        "https://cache.iog.io"
        "https://tweag-tricorder.cachix.org"
      ];
      nix.settings.trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "tweag-tricorder.cachix.org-1:PbwYPJ9gF8Wns14ai0sHK3iblqFd5YUrj0zEzGsJ/wg="
      ];
    };
  };
}
