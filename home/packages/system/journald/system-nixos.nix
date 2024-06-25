{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.system.journald.enable {
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
  };
}
