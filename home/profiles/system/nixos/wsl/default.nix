{ lib, config, ... }:
{
  options.gipphe.profiles.system.nixos.wsl.enable = lib.mkEnableOption "system.nixos.wsl";
  config = lib.mkIf config.gipphe.profiles.system.nixos.wsl.enable {
    gipphe.system.wsl.enable = true;
  };
}
