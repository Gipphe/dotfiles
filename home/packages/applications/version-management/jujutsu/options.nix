{ lib, ... }:
{
  options.gipphe.programs.jujutsu.enable = lib.mkEnableOption "jujutsu";
}
