{ lib, config, ... }:
{
  options.gipphe.profiles.nixos.zramswap.enable = lib.mkEnableOption "nixos.zramswap";
  config = lib.mkIf config.gipphe.profiles.nixos.zramswap.enable { gipphe.zramswap.enable = true; };
}
