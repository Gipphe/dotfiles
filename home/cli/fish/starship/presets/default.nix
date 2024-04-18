{
  lib,
  flavour,
  util,
  enable,
  pkgs,
  ...
}:
let
  id = x: x;
  presets = {
    bracketedSegments = id;
    catppuccinPalette = f: (f { inherit flavour pkgs; }) // { palette = "catppuccin_${flavour}"; };
    nerdfontSymbols = util.recursiveMap lib.mkForce;
    p3rception = id;
    pastelPowerline = id;
    tokyoNight = id;
  };
in
builtins.map (p: presets.${p} (import ./${p})) enable
