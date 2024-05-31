{ lib, flags, ... }:
lib.optionalAttrs (!flags.wsl) {
  imports = [
    ./efi.nix
    ./grub.nix
  ];
}
