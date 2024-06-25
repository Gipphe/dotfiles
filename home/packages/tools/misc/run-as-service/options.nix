{ lib, ... }:
{
  options.gipphe.programs.run-as-service.enable = lib.mkEnableOption "run-as-service";
}
