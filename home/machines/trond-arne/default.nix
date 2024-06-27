{
  lib,
  config,
  flags,
  ...
}:
{
  imports = lib.optional flags.isSystem ./system-all.nix;
  options.gipphe.machines.trond-arne.enable = lib.mkEnableOption "trond-arne machine config";
  config = lib.mkIf config.gipphe.machines.trond-arne.enable {
    gipphe.profiles = {
      core.enable = true;
      systemd.enable = true;
      audio.enable = true;
      desktop.enable = true;
      gaming.enable = true;
      fonts.enable = true;
    };
  };
}
