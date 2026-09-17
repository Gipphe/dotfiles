{
  perSystem = { self', pkgs, ... }: {
    devShells.default =
      let
        util = pkgs.callPackage ../../util.nix { };
      in
      pkgs.callPackage ./shell.nix {
        inherit (self'.packages) jujutsu;
        inherit (util) writeNushellApplication;
      };
  };
}
