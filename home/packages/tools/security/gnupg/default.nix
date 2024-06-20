{ lib, config, ... }:
{
  options.gipphe.programs.gpg.enable = lib.mkEnableOption "gpg";
  config = lib.mkIf config.gipphe.programs.gpg.enable { programs.gpg.enable = true; };
}
