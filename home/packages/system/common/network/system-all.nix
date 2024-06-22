{ flags, ... }:
{
  networking.hostName = flags.system.hostname;
}
