{ self, inputs, ... }: {
  imports = [
    inputs.treefmt-nix.flakeModule
    ./flake/checks.nix
    ./flake/devShells
    ./flake/environments
    ./flake/packages
    ./flake/pkgs.nix
    ./flake/treefmt.nix
  ];

  flake = {
    overlays = { };
    images.sodium = self.nixosConfigurations.sodium.config.system.build.image;
  };
}
