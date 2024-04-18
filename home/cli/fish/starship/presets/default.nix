{
  lib,
  flavour,
  util,
  enable,
  ...
}:
let
  id = x: x;
  presets = {
    bracketedSegments = id;
    catppuccinPalette = f: (f { inherit flavour; }) // { palette = "catppuccin_${flavour}"; };
    nerdfontSymbols = util.recursiveMap lib.mkForce;
    p3rception = id;
    pastelPowerline = id;
    tokyoNight = id;
  };
in
lib.mkMerge (builtins.map (p: presets.${p}) enable)
