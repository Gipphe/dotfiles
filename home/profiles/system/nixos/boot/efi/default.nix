{ lib, config, ... }:
{
  options.gipphe.profiles.system.nixos.boot.efi.enable = lib.mkEnableOption "system.nixos.boot.efi";
  config = lib.mkIf config.gipphe.profiles.system.nixos.boot.efi.enable {
    gipphe.boot.systemd-boot.enable = true;
  };
}
