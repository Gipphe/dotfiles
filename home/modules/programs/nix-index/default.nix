{ lib, flags, ... }:
{
  imports = lib.optional flags.isHm ./home-manager.nix;
}
