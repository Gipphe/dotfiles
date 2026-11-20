{ den, ... }:
{
  den.aspects.profiles.email.includes = [
    den.aspects.environment.email
    den.aspects.programs.aerc
    den.aspects.programs.himalaya
    den.aspects.programs.mbsync
    den.aspects.programs.neomutt
  ];
}
