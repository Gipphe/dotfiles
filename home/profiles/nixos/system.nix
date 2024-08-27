{ lib, config, ... }:
{
  options.gipphe.profiles.nixos.system.enable = lib.mkEnableOption "nixos.system profile";
  config = lib.mkIf config.gipphe.profiles.nixos.system.enable {
    gipphe.system = {
      console.enable = true;
      dconf.enable = true;
      journald.enable = true;
      keyboard.enable = true;
      localization.enable = true;
      nix-ld.enable = true;
      systemd.enable = true;
    };
  };
}
