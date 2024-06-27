{ lib, ... }:
{
  options.gipphe.programs.ssh.enable = lib.mkEnableOption "ssh";
}
