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
    overlays = { };
    images.sodium = self.nixosConfigurations.sodium.config.system.build.image;
  };
}
