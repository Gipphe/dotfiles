{ lib, ... }:
{
  options.gipphe.programs.jq.enable = lib.mkEnableOption "jq";
}
