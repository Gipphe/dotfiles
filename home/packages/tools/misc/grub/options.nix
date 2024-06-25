{ lib, ... }:
{
  options.gipphe.boot.grub.enable = lib.mkEnableOption "grub";
}
