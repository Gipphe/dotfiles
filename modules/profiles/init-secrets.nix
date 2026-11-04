{ den, ... }:
{
  den.aspects.profiles.init-secrets.includes = [
    den.aspects.environment.secrets
  ];
}
