{ lib, ... }:
{
  options.gipphe.programs.gnused.enable = lib.mkEnableOption "gnused";
}
