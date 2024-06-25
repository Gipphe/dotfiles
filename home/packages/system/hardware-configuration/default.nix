{ flags, lib, ... }:
let
  inherit (flags.system) hostname;
  configs = {
    "trond-arne" = ./trond-arne.nix;
    "nixos-vm" = ./nixos-vm.nix;
    "Jarle" = ./Jarle.nix;
  };
in
{
  imports = lib.optionals flags.isNixos [
    (configs.${hostname} or (throw "No hardware config found for ${hostname}"))
  ];
}
