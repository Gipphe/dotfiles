{ lib, config, ... }:
{
  config = lib.mkIf (config.gipphe.machine == "nixos-vm") {
    gipphe.profiles = {
      core = {
        enable = true;
        systemd.enable = true;
        audio.enable = true;
      };
      desktop = {
        enable = true;
      };
      libraries.fonts = true;
    };
  };
}
