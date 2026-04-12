{ lib }:
let
  inherit (lib) toLower;
  inherit (builtins)
    concatStringsSep
    isString
    attrNames
    ;
  toDispatch =
    action:
    if isString action.spawn then
      "exec, ${action.spawn}"
    else if isString action.shortcut then
      "global, ${action.shortcut}"
    else
      abort "Unknown keybind action: ${concatStringsSep ", " (attrNames action)}";
  replaceMod =
    s:
    let
      lowered = toLower s;
    in
    if lowered == "mod" || lowered == "$mod" then "$mod" else s;
  toMods =
    mods: if isString mods then replaceMod mods else concatStringsSep " " (map replaceMod mods);
  toHyprBindConfig = coreBind: {
    ${pickBindType coreBind} = [
      "${toMods coreBind.mod}, ${coreBind.key}, ${toDispatch coreBind.action}"
    ];
  };
  pickBindType =
    coreBind:
    if coreBind.args ? allow-when-locked && coreBind.args.allow-when-locked then "bindl" else "bind";
in
{
  inherit
    toHyprBindConfig
    ;
}
