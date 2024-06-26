{ lib, config, ... }:
{
  options.gipphe.profiles.system.nixos.boot.legacy.enable = lib.mkEnableOption "system.nixos.boot.legacy";
  config = lib.mkIf config.gipphe.profiles.system.nixos.boot.legacy.enable {
    gipphe.boot.grub.enable = true;
  };
}
