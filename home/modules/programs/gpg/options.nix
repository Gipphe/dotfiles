{ lib, ... }:
{
  options.gipphe.programs.gpg.enable = lib.mkEnableOption "gpg";
}
