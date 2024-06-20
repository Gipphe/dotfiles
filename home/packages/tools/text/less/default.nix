{ lib, config, ... }:
{
  options.gipphe.programs.less.enable = lib.mkEnableOption "less";
  config = lib.mkIf config.gipphe.programs.less.enable {
    programs.less.enable = true;
    home.sessionVariables.PAGER = "less -FXR";
  };
}
