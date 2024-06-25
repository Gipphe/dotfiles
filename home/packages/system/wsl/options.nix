{ lib, ... }:
{
  options.gipphe.system.wsl.enable = lib.mkEnableOption "wsl";
}
