{ den, ... }:
{
  den.aspects.profiles.systemd.includes = [ den.aspects.programs.run-as-service ];
}
