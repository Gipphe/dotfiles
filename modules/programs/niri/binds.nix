{ lib, bash }:
let
  inherit (lib) toLower pipe;
  inherit (builtins)
    isString
    concatStringsSep
    elemAt
    split
    stringLength
    filter
    ;
  trim =
    x:
    if x == "" then
      x
    else
      pipe x [
        (split "[[:space:]]")
        (filter (x: x == "" || !(isString x)))
        (concatStringsSep " ")
      ];
  replaceMod =
    s:
    let
      lowered = toLower s;
      sanitized = pipe s [
        trim
        (split "_")
        (filter (x: x != [ ]))
        (filter (x: isString x -> stringLength x > 1))
        (concatStringsSep "_")
      ];
    in
    if lowered == "mod" || lowered == "$mod" then "Mod" else sanitized;
  toMod =
    bind:
    if bind ? mod == false || (trim bind.mod) == "" then
      ""
    else
      let
        mod =
          if isString bind.mod then replaceMod bind.mod else concatStringsSep "+" (map replaceMod bind.mod);
      in
      "${mod}+";
  toNiriBind = bind: {
    name = "${toMod bind}${bind.key}";
    value =
      if bind.action ? spawn then
        {
          action.spawn = [
            "${bash}/bin/bash"
            "-c"
            bind.action.spawn
          ];
        }
      else
        { inherit (bind) action; };
  };
in
{
  inherit replaceMod toMod toNiriBind;
}
