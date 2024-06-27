{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.machines.Jarle.enable { networking.hostName = "Jarle"; };
}
