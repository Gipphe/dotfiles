{ lib, ... }:
{
  options.gipphe.programs.cyberduck.enable = lib.mkEnableOption "cyberduck";
}
