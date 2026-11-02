{ den, ... }:
{
  den.aspects.profiles.secrets.includes = [
    den.aspects.programs.ssh
    den.aspects.environment.secrets
  ];
}
