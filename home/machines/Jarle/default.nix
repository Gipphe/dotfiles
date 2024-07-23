{
  lib,
  config,
  flags,
  ...
}:
{
  imports =
    lib.optional flags.isSystem ./system-all.nix
    ++ lib.optional flags.isNixos ./system-nixos.nix;
  options.gipphe.machines.Jarle.enable = lib.mkEnableOption "Jarle machine config";
  config = lib.mkIf config.gipphe.machines.Jarle.enable {
    gipphe = {
      username = "gipphe";
      homeDirectory = "/home/gipphe";
      profiles = {
        nixos = {
          system.enable = true;
          wsl.enable = true;
        };
        ai.enable = true;
        cli.enable = true;
        containers.enable = true;
        core.enable = true;
        fonts.enable = true;
        gc.enable = true;
        rice.enable = true;
        secrets.enable = true;
        systemd.enable = true;
        vm-guest.enable = true;
        work-slim.enable = true;
      };
    };
  };
}
