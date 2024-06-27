{ lib, flags, ... }:
{
  imports = [
    ./options.nix
  ] ++ lib.optional flags.isHm ./home-manager.nix ++ lib.optional flags.isNixos ./system-nixos.nix;
}
