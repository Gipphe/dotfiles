{ den, ... }:
{
  den.aspects.profiles.email.includes = [
    den.aspects.environment.email
    den.aspects.programs.aerc
    # TODO: Reenable once fix is in nixos-unstable.
    # https://nixpk.gs/pr-tracker.html?pr=584922
    # den.aspects.programs.himalaya
    den.aspects.programs.mbsync
    den.aspects.programs.neomutt
  ];
}
