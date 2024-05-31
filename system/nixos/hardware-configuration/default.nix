{ flags, ... }:
let
  hostname = flags.hostname;
  configs = {
    "trond-arne" = ./trond-arne.nix;
    "nixos-vm" = ./nixos-vm.nix;
  };
in
{
  imports = [
    configs.${hostname} or throw
    "No hardware config found for ${hostname}"
  ];
}
