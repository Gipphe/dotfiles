{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (import ../../../../util.nix) recursiveMap;
  cfg = config.gipphe.programs.starship;
  flavour = "macchiato";
  catppuccinPalette = import ./catppuccinPalette { inherit pkgs flavour; };
  nerdfontSymbols = recursiveMap lib.mkForce (import ./nerdfontSymbols);

  # bracketedSegments = import ./bracketedSegments;
  # tokyoNight = import ./tokyoNight;
  pastelPowerline = import ./pastelPowerline;
in
# p3rception = import ./p3rception;
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
        # bracketedSegments
        # tokyoNight
        pastelPowerline
        # p3rception
        catppuccinPalette
        nerdfontSymbols
      ];
    };
    programs.fish.shellInit = lib.mkAfter ''
      ${config.programs.starship.package}/bin/starship init fish | source
    '';
  };
}
