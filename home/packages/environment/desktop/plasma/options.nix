{ lib, ... }:
{
  options.gipphe.environment.desktop.plasma.enable = lib.mkEnableOption "plasma";
}
