{ nixpkgs-last-working-for-nix-on-droid, self, ... }@inputs:
let
  nixpkgs = nixpkgs-last-working-for-nix-on-droid;
  inherit (nixpkgs) lib;
  inherit (lib.attrsets) filterAttrs mapAttrs;
  util = import ./util.nix { inherit lib; };

  hosts = filterAttrs (_: c: c.machine == "nix-on-droid") util.hosts;

  flags = {
    isNixos = false;
    isNixOnDroid = true;
    isHomeManager = false;
    isSystem = true;
  };

  mkMachine =
    hostname: config:
    let
      util = nixpkgs.legacyPackages.${config.system}.callPackage ../util.nix { };
    in
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import nixpkgs {
        system = "aarch64-linux";
        config.allowUnfree = true;
      };
      extraSpecialArgs = {
        inherit
          inputs
          self
          hostname
          flags
          util
          ;
        environment = "nixOnDroid";
      };
      modules = [
        ../root.nix
        { gipphe.hosts.${hostname}.enable = true; }
      ];
    };
in
{
  nixOnDroidConfigurations = mapAttrs mkMachine hosts;
}
