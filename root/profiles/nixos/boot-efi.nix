{ lib, config, ... }:
{
  options.gipphe.profiles.nixos.boot-efi.enable = lib.mkEnableOption "nixos.boot-efi profile";
  config = lib.mkIf config.gipphe.profiles.nixos.boot-efi.enable {
    gipphe.boot.systemd-boot.enable = true;
  };
}
