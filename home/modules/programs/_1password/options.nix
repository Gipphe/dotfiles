{ lib, ... }:
{
  options.gipphe.programs._1password.enable = lib.mkEnableOption "_1password";
}
