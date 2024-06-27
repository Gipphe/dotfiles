{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.less.enable {
    programs.less.enable = true;
    home.sessionVariables.PAGER = "less -FXR";
  };
}
