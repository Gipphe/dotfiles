{ lib }:
let
  inherit (lib) toLower;
  inherit (builtins)
    concatStringsSep
    isString
    attrNames
    ;
  toLua = lib.generators.toLua { };
  toDispatch =
    action:
    if isString action.spawn then
      lib.mkLuaInline "hl.dsp.exec_cmd(${toLua action.spawn})"
    else if isString action.shortcut then
      lib.mkLuaInline "hl.dsp.global(${toLua action.shortcut})"
    else
      abort "Unknown keybind action: ${concatStringsSep ", " (attrNames action)}";
  replaceMod =
    s:
    let
      lowered = toLower s;
    in
    if lowered == "mod" || lowered == "$mod" then "SUPER" else s;
  toMods =
    mods:
    if isString mods then
      "${replaceMod mods} + "
    else if builtins.isList mods then
      "${concatStringsSep " + " (map replaceMod mods)} + "
    else
      "";
  toHyprBindConfig =
    coreBind:
    {
      key = "${toMods coreBind.mod}${coreBind.key}";
      dispatcher = toDispatch coreBind.action;
    }
    // mkFlags coreBind;
  mkFlags =
    coreBind:
    if coreBind.args ? allow-when-locked && coreBind.args.allow-when-locked then
      { locked = true; }
    else
      { };
in
{
  inherit toHyprBindConfig;
}
