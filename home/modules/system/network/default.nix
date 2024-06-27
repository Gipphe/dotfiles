{ lib, flags, ... }:
{
  imports = lib.optional flags.isSystem ./system-all.nix;
}
