{ lib, config, ... }:
{
  options.gipphe.profiles.work-slim.enable = lib.mkEnableOption "work-slim profile";
  config = lib.mkIf config.gipphe.profiles.work-slim.enable {
    gipphe.programs = {
      idea-ultimate.enable = true;
    };
  };
}
