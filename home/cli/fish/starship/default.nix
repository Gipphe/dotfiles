{
  lib,
  config,
  pkgs,
  ...
}:
let
  util = import ../../../../util.nix { inherit lib; };
  cfg = config.gipphe.programs.starship;
  flavour = "macchiato";
in
{
  options.gipphe.programs.starship = {
    enable = lib.mkEnableOption "starship";
  };
  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableTransience = true;
      settings = lib.mkMerge [
        {
          # format = "$all";
          palette = "catppuccin_${flavour}";
        }
        (import ./presets {
          inherit pkgs flavour util;
          enable = [
            "catppuccinPalette"
            "bracketedSegments"
            "nerdfontSymbols"
          ];
        })
      ];
    };
  };
}
