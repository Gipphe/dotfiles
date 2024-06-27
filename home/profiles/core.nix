{ lib, config, ... }:
{
  options.gipphe.profiles.core.enable = lib.mkEnableOption "core profile";
  config = lib.mkIf config.gipphe.profiles.core.enable {
    gipphe.programs = {
      nix.enable = true;
    };
  };
}
