{ inputs, ... }:
{
  den.aspects.programs.maki.homeManager = { pkgs, ... }: {
    home.packages = [
      inputs.maki.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
