{ lib, flags, ... }:
{
  imports =
    lib.optional flags.isNixDarwin ./system-darwin.nix
    ++ lib.optional flags.isNixos ./system-nixos.nix;
}
