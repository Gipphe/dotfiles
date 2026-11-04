{ den, ... }:
{
  den.aspects.profiles.vm-host.includes = [ den.aspects.programs.qemu ];
}
