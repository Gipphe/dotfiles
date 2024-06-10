{ flags, ... }:
let
  inherit (flags.sys) hostname;
  configs = {
    "trond-arne" = ./trond-arne.nix;
    "nixos-vm" = ./nixos-vm.nix;
    "Jarle" = ./Jarle.nix;
  };
in
{
  imports = [ (configs.${hostname} or (throw "No hardware config found for ${hostname}")) ];
}
