{ lib, ... }:
let
  inherit (lib)
    assertMsg
    concatStrings
    concatStringsSep
    filter
    generators
    isAttrs
    isDerivation
    isFloat
    isInt
    isList
    isString
    map
    mapAttrsToList
    match
    toLower
    ;
  inherit (generators) toPretty;
in
{
  profileOpt = options: lib.mkOption {
    description = ''
      List of profiles and their Windows setups to configure.
    '';
    type = with lib.types; attrsOf (submodule {
      inherit options;
    });
  };

  toPowershell = {
    multiline ? true,
    indent ? "",
    asBindings ? false,
  }@args: v:
    let
      innerIndent = "${indent}  ";
      introSpace = if multiline then "\n${innerIndent}" else " ";
      outroSpace = if multiline then "\n${indent}" else " ";
      innerArgs = args // {
        indent = if asBindings then indent else innerIndent;
        asBindings = false;
      };
      concatItems = concatStringsSep ",${introSpace}";
      isPowershellInline = { _type ? null, ... }: _type == "powershell-inline";

      generatedBindings =
        assert assertMsg (badVarNames == []) "Bad Powershell var names: ${toPretty {} badVarNames}";
        assert assertMsg (collidingNames == []) "Name collisions in Powershell var names: ${toPretty {} (map (n: n.name) collidingNames)}";
        concatStrings (
          mapAttrsToList (key: value: "${indent}${key} = ${toPowershell innerArgs value}\n") v
        );
      matchVarName = match "[[:alpha:]_][[:alnum:]_]*(\\.[[:alpha:]_][[:alnum:]_]*)*";
      badVarNames = filter (name: matchVarName name == null) (attrNames v);
      loweredNames = map (name: { inherit name; lowered = toLower n; }) (attrNames v);
      collidingNames = filter ({ name, lowered }: length (filter (x: x.lowered == lowered) loweredNames) > 1) loweredNames;
    in
    if asBindings then
      generatedBindings
    else if v == null then
      "$null"
    else if isInt v || isFloat v || isString v then
      toJSON v
    else if isBool v then
      "$$${toJSON v}"
    else if isList v then
      if v == [] then
        "@()"
      else
        "@(${introSpace}${concatItems (map (value: "${toPowershell innerArgs value}") v)}${outroSpace})"
    else if isAttrs v then
      if isPowershellInline v then
        "(${v.expr})"
      else if v == {} then
        "@{}"
      else if isDerivation v then
        ''"${toString v}"''
      else
        "@{${introSpace}${concatItems (
          mapAttrsToList (key: value: ''"${toJSON key}" = ${toPowershell innerArgs value}'') v
        )}${outroSpace}}"
    else
      abort "toPowershell: type ${typeOf v} is unsupported";

  mkPowershellInline = expr: { _type = "powershell-inline"; inherit expr; };


  powershellInlineType =
    with lib.types;
    submodule {
      options = {
        _type = lib.mkOption {
          type = enum ["powershell-inline"];
        };
      };
    };
}
