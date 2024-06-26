{ lib, config, ... }:
{
  options.gipphe.profiles.system.nixos.enable = lib.mkEnableOption "system.nixos";
  config = lib.mkIf config.gipphe.profiles.system.nixos.enable {
    gipphe.system = {
      console.enable = true;
      journald.enable = true;
      keyboard.enable = true;
      localization.enable = true;
      nix-ld.enable = true;
      systemd.enable = true;
      user.enable = true;
    };
  };
}
