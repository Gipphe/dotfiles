{ den, ... }:
{
  den.aspects.profiles.nixos.power.includes = [
    den.aspects.programs.powertop
    den.aspects.programs.upower
  ];
}
