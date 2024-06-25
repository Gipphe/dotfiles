{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.ssh.enable { programs.ssh.startAgent = true; };
}
