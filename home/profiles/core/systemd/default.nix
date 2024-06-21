{ lib, config, ... }:
{
  options.gipphe.profiles.core.systemd.enable = lib.mkEnableOption "core.systemd profile";
  config = lib.mkIf config.gipphe.profiles.core.systemd.enable {
    gipphe.programs.run-as-service.enable = true;
  };
}
