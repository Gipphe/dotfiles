{ lib, config, ... }:
{
  options.gipphe.profiles.nixos.power.enable = lib.mkEnableOption "nixos.power profile";
  config = lib.mkIf config.gipphe.profiles.nixos.power.enable {
    gipphe.programs.upower.enable = true;
  };
}
