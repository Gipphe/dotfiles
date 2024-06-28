{ lib, flags, ... }:
{
  imports =
    [ ./options.nix ]
    ++ lib.optional flags.isNixDarwin ./system-darwin.nix
    ++ lib.optional flags.isSystem ./system-all.nix;
}
