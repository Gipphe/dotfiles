{ self, inputs, ... }: {
  imports = [
    inputs.treefmt-nix.flakeModule
    ./flake/devShells
    ./flake/environments
    ./flake/packages
    ./flake/treefmt.nix
    ./flake/checks.nix
  ];

  flake = {
    overlays = {
      lix = final: prev: {
        inherit (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena
          ;
        nix = prev.lixPackageSets.stable.lix;
      };
    };
    images.sodium = self.nixosConfigurations.sodium.config.system.build.image;
  };
}
