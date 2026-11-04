{ den, ... }:
{
  den.aspects.profiles.nixos.printing.includes = [
    den.aspects.system.printer
  ];
}
