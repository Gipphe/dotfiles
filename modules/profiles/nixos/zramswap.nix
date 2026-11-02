{ den, ... }:
{
  den.aspects.profiles.nixos.zramswap.includes = [
    den.aspects.system.zramswap
  ];
}
