{ nixpkgs, self, ... }@inputs:
let
  inherit (nixpkgs) lib;
  inherit (lib.attrsets) filterAttrs mapAttrs;
  inherit (import ./util.nix { inherit lib; }) enumerateMachines;

  machines = filterAttrs (_: c: c.machine == "nix-on-droid") (enumerateMachines ../machines);

  flags = {
    isNixos = false;
    isNixOnDroid = true;
    isHm = false;
    isSystem = true;
  };

  mkMachine =
    hostname: config:
    let
      util = nixpkgs.legacyPackages.${config.system}.callPackage ../util.nix { };
    in
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import nixpkgs {
        system = "aarch64-linix";
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
      };
      modules = [
        ../root.nix
        { gipphe.machines.${hostname}.enable = true; }
      ];
    };
in
{
  nixOnDroidConfigurations = mapAttrs mkMachine machines;
}
