{ den, ... }:
{
  den.aspects.profiles.nixos.boot.includes = [
    den.aspects.boot.limine
  ];
}
