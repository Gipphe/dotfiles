{
  self,
  withSystem,
  inputs,
  ...
}:
let
  hostName = "boron";
  system = "x86_64-linux";
  pkgs = withSystem system ({ pkgs, ... }: pkgs);
  util = inputs.flaketilities.lib.${pkgs.stdenv.hostPlatform.system};
in
{
  flake.nixosConfigurations.${hostName} = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs self util;
      inherit (inputs) nixos-raspberry;
      hostname = hostName;
      environment = "nixos";
      flags = {
        isNixos = true;
        isNixOnDroid = false;
        isHomeManager = false;
        isSystem = true;
      };
    };
    modules = [
      ../../root.nix
      {
        nixpkgs.pkgs = pkgs;
        gipphe = {
          inherit hostName;
          hosts.${hostName}.enable = true;
        };
      }
    ];
  };
}
