{
  lib,
  config,
  # pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.starship;
  # flavour = "macchiato";
  # catppuccinPalette = import ./catppuccinPalette { inherit pkgs flavour; };
  # nerdfontSymbols = import ./nerdfontSymbols;
  # bracketedSegments = import ./bracketedSegments;
  tokyoNight = import ./tokyoNight;
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
          # palette = "catppuccin_${flavour}";
        }
        # catppuccinPalette
        # nerdfontSymbols
        # bracketedSegments
        tokyoNight
      ];
    };
    programs.fish.shellInit = lib.mkAfter ''
      ${config.programs.starship.package}/bin/starship init fish | source
    '';
  };
}
