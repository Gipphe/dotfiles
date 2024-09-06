{ lib, config, ... }:
{
  options.gipphe.profiles.nixos.boot-legacy.enable = lib.mkEnableOption "nixos.boot-legacy profile";
  config = lib.mkIf config.gipphe.profiles.nixos.boot-legacy.enable {
    gipphe.boot.grub.enable = true;
  };
}
