{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.starship;
in
{
  options.gipphe.programs.starship = {
    enable = lib.mkEnableOption "starship";
  };
  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableTransience = true;
      settings = import ./presets/preset.nix { inherit pkgs lib; };
    };
  };
}
