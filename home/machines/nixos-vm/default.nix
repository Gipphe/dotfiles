{
  lib,
  config,
  flags,
  ...
}:
{
  imports = lib.optional flags.isSystem ./system-all.nix;
  options.gipphe.machines.nixos-vm.enable = lib.mkEnableOption "nixos-vm machine config";
  config = lib.mkIf config.gipphe.machines.nixos-vm.enable {
    gipphe.profiles = {
      core.enable = true;
      systemd.enable = true;
      audio.enable = true;
      desktop.enable = true;
      fonts.enable = true;
    };
  };
}
