{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.system.journald.enable {
    services.journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
  };
}
