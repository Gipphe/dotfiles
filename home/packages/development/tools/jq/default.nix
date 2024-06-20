{ lib, config, ... }:
{
  options.gipphe.programs.jq.enable = lib.mkEnableOption "jq";
  config = lib.mkIf config.gipphe.programs.jq.enable { programs.jq.enable = true; };
}
