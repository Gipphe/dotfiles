{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.fish.enable {
    programs.starship = {
      enable = true;
      enableTransience = true;
      settings = import ./presets { inherit pkgs lib; };
    };
  };
}
