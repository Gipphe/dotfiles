{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.cool-retro-term.enable {
    home.packages = with pkgs; [ cool-retro-term ];
  };
}
