{ config, ... }:
{
  networking.hostName = config.gipphe.flags.hostname;
}
