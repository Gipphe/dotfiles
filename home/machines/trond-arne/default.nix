{ lib, config, ... }:
{
  config = lib.mkIf (config.gipphe.machine == "trond-arne") {
    gipphe.profiles = {
      core = {
        enable = true;
        systemd.enable = true;
        audio.enable = true;
      };
      desktop = {
        enable = true;
        gaming.enable = true;
      };
      libraries.fonts = true;
    };
  };
}
