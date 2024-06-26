{ lib, config, ... }:
{
  options.gipphe.profiles.system.nixos.audio.enable = lib.mkEnableOption "system.nixos.audio";
  config = lib.mkIf config.gipphe.profiles.system.nixos.audio.enable {
    gipphe.system.audio.enable = true;
  };
}
