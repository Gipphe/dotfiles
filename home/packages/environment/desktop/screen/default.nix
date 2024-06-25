{ lib, flags, ... }:
{
  imports = lib.optionals flags.isNixos ./system-nixos.nix;
}
