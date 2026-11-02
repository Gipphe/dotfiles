{ den, ... }:
{
  den.aspects.profiles.containers.includes = [
    den.aspects.programs.docker
    den.aspects.programs.lazydocker
  ];
}
