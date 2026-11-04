{ den, ... }:
{
  den.aspects.profiles.nixos.networking.includes = [
    den.aspects.system.networking
  ];
}
