{ lib, writeShellScriptBin, ... }:
let
  inherit (builtins)
    hasAttr
    map
    isList
    isAttrs
    listToAttrs
    readDir
    attrNames
    ;
  inherit (lib) flatten;
  inherit (lib.attrsets) foldlAttrs filterAttrs;

  recursiveMap =
    f: x:
    let
      recurseAttrs =
        set:
        listToAttrs (
          map (k: {
            name = k;
            value = recursiveMap f set.${k};
          }) (attrNames set)
        );
      recurseList = list: map (recursiveMap f) list;
    in
    if isList x then
      recurseList x
    else if isAttrs x then
      recurseAttrs x
    else
      f x;

  importSiblings =
    let
      go =
        acc: fileName: _:
        acc ++ (if fileName != "default.nix" then [ fileName ] else [ ]);
    in
    dir:
    lib.pipe dir [
      readDir
      (lib.attrsets.foldlAttrs go [ ])
      (map (f: /.${dir}/${f}))
    ];

  mkCopyActivationScript =
    fromDir: toDir:
    writeShellScriptBin "script" ''
      rm -rf "${toDir}"
      cp -rL "${fromDir}" "${toDir}"
    '';

  setCaskHash =
    cask: hash:
    cask.overrideAttrs (c: {
      src = cask.src.overrideAttrs { outputHash = hash; };
    });

  recurseFirstMatching =
    file: dir:
    lib.pipe dir [
      readDir
      (filterAttrs (_: type: type == "directory"))
      attrNames
      (map (d: /.${dir}/${d}))
      (map (recurseFirstMatching' file))
      flatten
    ];
  recurseFirstMatching' =
    file: dir:
    let
      items = readDir dir;
    in
    if hasAttr file items && items.${file} == "regular" then
      [ /.${dir}/${file} ]
    else
      foldlAttrs (
        acc: name: type:
        if type == "directory" then acc ++ recurseFirstMatching' file /.${dir}/${name} else acc
      ) [ ] items;

  mkSimpleProgram =
    name: package:
    {
      lib,
      config,
      flags,
      ...
    }:
    {
      options.gipphe.programs.${name}.enable = lib.mkEnableOption name;
    }
    // (lib.optionalAttrs flags.isHm {
      config = lib.mkIf config.gipphe.programs.${name}.enable { home.packages = [ package ]; };
    });

  mkSimpleProgramByName = name: { pkgs, ... }@args: mkSimpleProgram name pkgs.${name} args;
  mkSimpleProgramImports = name: [ (mkSimpleProgramByName name) ];
in
{
  inherit
    importSiblings
    mkCopyActivationScript
    mkSimpleProgram
    recurseFirstMatching
    recursiveMap
    setCaskHash
    mkSimpleProgramByName
    mkSimpleProgramImports
    ;
}
