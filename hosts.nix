{ nixpkgs, self, ... }@inputs:
let
  machines = {
    Jarle.system = "x86_64-linux";
    nixos-vm.system = "x86_64-linux";
    trond-arne.system = "x86_64-linux";
    VNB-MB-Pro.system = "aarch64-darwin";
  };
  inherit (nixpkgs.lib.attrsets) filterAttrs mapAttrs;
  inherit (nixpkgs.lib) nixosSystem hasSuffix;
  inherit (inputs.darwin.lib) darwinSystem;

  nixosMachines = filterAttrs (_: config: !(hasSuffix "darwin" config.system)) machines;
  darwinMachines = filterAttrs (_: config: hasSuffix "darwin" config.system) machines;

  nixosFlags = {
    isNixos = true;
    isNixDarwin = false;
    isHm = false;
    isSystem = true;
  };
  darwinFlags = {
    isNixos = false;
    isNixDarwin = true;
    isHm = false;
    isSystem = true;
  };
  nixosConfigurations = mapAttrs (mkMachine nixosFlags nixosSystem) nixosMachines;
  darwinConfigurations = mapAttrs (mkMachine darwinFlags darwinSystem) darwinMachines;

  mkMachine =
    flags: mkSystem: hostname: config:
    mkSystem {
      inherit (config) system;
      specialArgs = {
        inherit
          inputs
          self
          hostname
          flags
          ;
        util =
          let
            utilPkgs = nixpkgs.legacyPackages.${config.system};
          in
          import ./util.nix { inherit (utilPkgs) writeShellScriptBin lib system; };
      };
      modules = [
        ./home
        { gipphe.machines.${hostname}.enable = true; }
      ];
    };
in
{
  inherit nixosConfigurations;
  inherit darwinConfigurations;
}
