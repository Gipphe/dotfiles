{ den, ... }:
{
  den.aspects.profiles.nixos.bluetooth.includes = [
    den.aspects.system.bluetooth
  ];
}
