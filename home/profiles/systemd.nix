{ lib, config, ... }:
{
  options.gipphe.profiles.systemd.enable = lib.mkEnableOption "systemd profile";
  config = lib.mkIf config.gipphe.profiles.systemd.enable {
    gipphe.programs.run-as-service.enable = true;
  };
}
