{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.cool-retro-term.enable = lib.mkEnableOption "cool-retro-term";
  config = lib.mkIf config.gipphe.programs.cool-retro-term.enable {
    home.packages = with pkgs; [ cool-retro-term ];
  };
}
