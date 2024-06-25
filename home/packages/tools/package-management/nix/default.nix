{ lib, flags, ... }:
{
  imports =
    [ ./options.nix ]
    ++ lib.optional flags.isSystem ./system-all.nix
    ++ lib.optional flags.isNixos ./system-nixos.nix
    ++ lib.optional flags.isNixDarwin ./system-darwin.nix;
}
