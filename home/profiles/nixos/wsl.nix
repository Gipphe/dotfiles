{ lib, config, ... }:
{
  options.gipphe.profiles.nixos.wsl.enable = lib.mkEnableOption "nixos.wsl";
  config = lib.mkIf config.gipphe.profiles.nixos.wsl.enable { gipphe.system.wsl.enable = true; };
}
