{ lib, flags, ... }:
{
  imports = lib.optional flags.isNixos ./system-nixos.nix;
}
