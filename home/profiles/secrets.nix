{ lib, config, ... }:
{
  options.gipphe.profiles.secrets.enable = lib.mkEnableOption "secrets";
  config = lib.mkIf config.gipphe.profiles.secrets.enable {
    gipphe.environment.secrets.enable = true;
  };
}
