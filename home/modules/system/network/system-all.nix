{ flags, ... }:
{
  networking.hostName = flags.hostname;
}
