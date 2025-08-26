{
  pkgs,
  util,
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (builtins) listToAttrs isString concatStringsSep;
  inherit (lib) toLower;
  replaceMod =
    s:
    let
      lowered = toLower s;
    in
    if lowered == "mod" || lowered == "$mod" then "Mod" else s;
  toMod =
    mod: (if isString mod then replaceMod mod else concatStringsSep "+" (map replaceMod mod)) ++ "+";
  toNiriBind = bind: {
    name = "${toMod bind.mod}${bind.key}";
    value = { inherit (bind) action; };
  };
  coreBinds = listToAttrs (map toNiriBind config.gipphe.core.wm.binds);
in
util.mkModule {
  shared.imports = [
    (util.mkProgram {
      name = "niri";
      hm.programs.niri = {
        enable = true;
        settings = {
          binds = coreBinds;
          keyboard = {
            numlock = true;
            xkb = {
              layout = "no";
            };
          };
          output = {
            "Dell Inc. DELL U2724D G11T4Z3" = "center";
            "Dell Inc. DELL U2724D G27V4Z3" = "right";
            "Dell Inc. DELL U2724D G15V4Z3" = "left";
          };
          xwayland-sattellite = {
            path = "${pkgs.xwayland-sattellite-unstable}";
          };
        };
      };
    })
  ];
  hm.imports = [ inputs.niri.homeModules.niri ];
  system-nixos = {
    imports = [ inputs.niri.nixosModules.niri ];
  };
}
