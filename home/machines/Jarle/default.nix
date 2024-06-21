{ lib, config, ... }:
{
  config = lib.mkIf (config.gipphe.machine == "Jarle") {
    gipphe.profiles = {
      core = {
        enable = true;
        systemd.enable = true;
      };
      desktop = {
        work.enable = true;
      };
      libraries.fontconfig = true;
    };
  };
}
