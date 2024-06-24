{ lib, flags, ... }:
{
  imports =
    lib.optional flags.isSystem ./system-all.nix
    ++ lib.optional flags.isNixDarwin ./system-darwin.nix;
}
