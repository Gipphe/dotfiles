{ lib, ... }:
{
  options.gipphe.programs.slack.enable = lib.mkEnableOption "slack";
}
