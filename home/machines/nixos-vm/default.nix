{ lib, config, ... }:
{
  options.gipphe.machines.nixos-vm.enable = lib.mkEnableOption "nixos-vm machine config";
  config = lib.mkIf config.gipphe.machines.nixos-vm.enable {
    gipphe = {
      hostName = "nixos-vm";
      profiles = {
        nixos = {
          audio.enable = true;
          boot-legacy.enable = true;
          devices.enable = true;
          system.enable = true;
          zramswap.enable = true;
        };
        cli.enable = true;
        audio.enable = true;
        core.enable = true;
        desktop-normal.enable = true;
        desktop.enable = true;
        fonts.enable = true;
        secrets.enable = true;
        systemd.enable = true;
        vm-guest.enable = true;
      };
    };
  };
}
