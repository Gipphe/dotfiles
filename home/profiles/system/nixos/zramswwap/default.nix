{ lib, config, ... }:
{
  options.gipphe.profiles.system.nixos.zramswap.enable = lib.mkEnableOption "system.nixos.zramswap";
  config = lib.mkIf config.gipphe.profiles.system.nixos.zramswap.enable {
    gipphe.system.zramswap.enable = true;
  };
}
