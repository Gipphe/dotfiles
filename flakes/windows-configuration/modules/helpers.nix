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
  isRaw = x: x ? __raw;
  rawType =
    with lib.types;
    submodule {
      options = {
        __raw = oneOf [
          str
          number
        ];
      };
    };
  toPSValue =
    x:
    if isString x then
      "'${x}'"
    else if isAttrs x && x ? __raw then
      "${x.__raw}"
    else
      "${toString x}";
}
