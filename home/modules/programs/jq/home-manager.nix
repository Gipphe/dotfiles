{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.jq.enable { programs.jq.enable = true; };
}
