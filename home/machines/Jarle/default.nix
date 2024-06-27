{
  lib,
  config,
  flags,
  ...
}:
{
  imports = lib.optional flags.isSystem ./system-all.nix;
  options.gipphe.machines.Jarle.enable = lib.mkEnableOption "Jarle machine config";
  config = lib.mkIf config.gipphe.machines.Jarle.enable {
    gipphe = {
      username = "gipphe";
      homeDirectory = "/home/gipphe";
      profiles = {
        containers.enable = true;
        core.enable = true;
        fonts.enable = true;
        nixos = {
          system.enable = true;
          wsl.enable = true;
        };
        rice.enable = true;
        secrets.enable = true;
        systemd.enable = true;
        vm-guest.enable = true;
        work.enable = true;
      };
    };
  };
}
