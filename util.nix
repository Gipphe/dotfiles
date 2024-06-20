{ lib, pkgs, ... }:
let
  inherit (builtins)
    isList
    isAttrs
    listToAttrs
    attrNames
    ;

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
in
{
  inherit recursiveMap;

  importSiblings =
    let
      go =
        acc: fileName: _:
        acc ++ (if fileName != "default.nix" then [ fileName ] else [ ]);
    in
    dir:
    lib.pipe dir [
      builtins.readDir
      (lib.attrsets.foldlAttrs go [ ])
      (builtins.map (f: "./${f}"))
    ];
  mkCopyActivationScript =
    fromDir: toDir:
    pkgs.writeShellScriptBin "script" ''
      rm -rf "${toDir}"
      cp -rL "${fromDir}" "${toDir}"
    '';

  setCaskHash =
    cask: hash:
    cask.overrideAttrs (c: {
      src = cask.src.overrideAttrs { outputHash = hash; };
    });
}
