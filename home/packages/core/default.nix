{ lib, flags, ... }:
{
  imports =
    lib.optionals flags.isHm [
      ./xdg.nix
      ./home.nix
      ./darwin.nix
    ]
    ++ lib.optional flags.isNixDarwin ./system-darwin.nix
    ++ lib.optional flags.isNixos ./system-nixos.nix;
}
