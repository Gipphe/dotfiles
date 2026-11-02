{
  self,
  withSystem,
  inputs,
  ...
}:
let
  hostName = "carbon";
  system = "aarch64-linux";
  pkgs = withSystem system ({ pkgs, ... }: pkgs);
  util = inputs.flaketilities.lib.${pkgs.stdenv.hostPlatform.system};
in
{
  flake.nixosConfigurations.${hostName} = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit inputs self util;
      inherit (inputs) nixos-raspberry;
      hostname = hostName;
      environment = "nixOnDroid";
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
        gipphe = {
          inherit hostName;
          hosts.${hostName}.enable = true;
        };
      }
    ];
  };
}
