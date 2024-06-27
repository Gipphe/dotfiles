{ lib, config, ... }:
{
  options.gipphe.profiles.nixos.audio.enable = lib.mkEnableOption "nixos.audio profile";
  config = lib.mkIf config.gipphe.profiles.nixos.audio.enable { gipphe.system.audio.enable = true; };
}
