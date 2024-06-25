{ lib, ... }:
{
  options.gipphe.services.printer.enable = lib.mkEnableOption "printer";
}
