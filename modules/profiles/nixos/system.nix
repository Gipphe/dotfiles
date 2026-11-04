{ den, ... }:
{
  den.aspects.profiles.nixos.system.includes = [
    den.aspects.system.console
    den.aspects.system.dconf
    den.aspects.system.journald
    den.aspects.system.keyboard
    den.aspects.system.localization
    den.aspects.system.nix-ld
    den.aspects.system.systemd
  ];
}
