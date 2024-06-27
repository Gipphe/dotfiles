{ lib, ... }:
{
  options.gipphe.system.user.enable = lib.mkEnableOption "user";
}
