{ lib, flags, ... }:
lib.optionalAttrs (!flags.virtualisation.wsl) {
  imports = [
    ./efi.nix
    ./grub.nix
  ];
}
