{ den, ... }:
{
  den.aspects.profiles.nixos.time.includes = [
    den.aspects.programs.automatic-timezoned
    den.aspects.programs.chrony
  ];
}
