{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.starship;
  flavour = "macchiato";
  catppuccinPalette = import ./catppuccinPalette { inherit pkgs flavour; };
  nerdfontSymbols = import ./nerdfontSymbols;
  bracketedSegments = import ./bracketedSegments;
in
{
  options.gipphe.programs.starship = {
    enable = lib.mkEnableOption "starship";
  };
  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableTransience = true;
      settings = {
        format = "$all";
        palette = "catppuccin_${flavour}";
      } // catppuccinPalette // nerdfontSymbols // bracketedSegments;
    };
    programs.fish.shellInit = lib.mkAfter ''
      ${config.programs.starship.package}/bin/starship init fish | source
    '';
  };
}
