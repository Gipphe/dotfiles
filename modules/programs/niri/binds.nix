{ lib, bash }:
let
  inherit (lib) toLower pipe;
  inherit (builtins)
    concatStringsSep
    filter
    isList
    isString
    length
    split
    stringLength
    typeOf
    ;
  replaceMod =
    s:
    let
      lowered = toLower s;
      sanitized = pipe s [
        (split "_")
        (filter (x: x != [ ]))
        (filter (x: isString x -> stringLength x > 1))
        (concatStringsSep "_")
      ];
    in
    if lowered == "mod" || lowered == "$mod" then "Mod" else sanitized;
  toMod =
    mod:
    if (isString mod && mod == "") || (isList mod && length mod == 0) then
      ""
    else
      let
        m =
          if isString mod then
            replaceMod mod
          else if isList mod then
            concatStringsSep "+" (map replaceMod mod)
          else
            abort "Invalid value for mod: ${typeOf mod}";
      in
      "${m}+";
  toNiriBind =
    {
      key,
      mod ? [ ],
      action,
    }:
    {
      name = "${toMod mod}${key}";
      value =
        if isString action.spawn then
          {
            action.spawn = [
              "${bash}/bin/bash"
              "-c"
              action.spawn
            ];
          }
        else if isString action.shortcut then
          abort "DBus global shortcuts have not been implemented for Niri"
        else
          { inherit action; };
    };
in
{
  inherit replaceMod toMod toNiriBind;
}
