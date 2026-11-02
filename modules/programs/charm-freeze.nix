{ inputs, ... }: {
  den.aspects.programs.charm-freeze = {
    homeManager =
      { pkgs, ... }:
      let
        pkg = inputs.flaketilities.lib.${pkgs.stdenv.hostPlatform.system}.mkOnDemand pkgs.charm-freeze;
      in
      {
        home.packages = [ pkg ];
      };
  };
}
