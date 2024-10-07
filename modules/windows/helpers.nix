{ lib, ... }:
let
  inherit (builtins)
    isString
    map
    toString
    isAttrs
    ;
in
{
  concatStringsList = xs: lib.concatStringsSep ", " (map (s: "\"${s}\"") xs);
  mkRaw = x: { __raw = x; };
  toPSValue =
    x:
    if isString x then
      "'${x}'"
    else if isAttrs x && x ? __raw then
      "${x.__raw}"
    else
      "${toString x}";
}
