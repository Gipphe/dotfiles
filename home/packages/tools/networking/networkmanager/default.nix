{ lib, flags, ... }:
{
  imports = [ ./options.nix ] ++ lib.optional flags.isNixos ./system-nixos.nix;
}
