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
  toHyprBind = coreBind: "${toMods coreBind.mod}, ${coreBind.key}, ${toDispatch coreBind.action}";
  toWarningMsgs =
    coreBind:
    let
      mod = toMods coreBind.mod;
    in
    lib.optional (hasUnsupportedArgs coreBind) ''
      Corebind ${if mod == "" then "" else "${mod}+"}${coreBind.key} has unsupported "args"
    '';
  hasUnsupportedArgs = coreBind: coreBind.args != { };
in
{
  inherit toHyprBind toWarningMsgs hasUnsupportedArgs;
}
