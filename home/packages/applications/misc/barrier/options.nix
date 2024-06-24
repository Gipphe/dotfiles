{ lib, ... }:
{
  options.gipphe.programs.barrier.enable = lib.mkEnableOption "barrier";
}
