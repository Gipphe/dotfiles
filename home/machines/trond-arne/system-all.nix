{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.machines.trond-arne.enable { networking.hostName = "trond-arne"; };
}
