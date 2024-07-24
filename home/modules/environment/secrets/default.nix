{ lib, flags, ... }:
{
  imports =
    [ ./options.nix ]
    ++ lib.optional flags.isNixos ./system-nixos.nix
    ++ lib.optional flags.isNixDarwin ./system-darwin.nix
    ++ lib.optional flags.isHm ./home-manager.nix;
}
