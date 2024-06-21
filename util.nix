{ lib, writeShellScriptBin, ... }:
let
  inherit (builtins)
    filter
    map
    isList
    isAttrs
    listToAttrs
    readDir
    attrNames
    ;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.attrsets) foldlAttrs;

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
      (map (f: "./${f}"))
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

  importSiblingNixDarwinDirs = importSubdirs "nix-darwin.nix";

  importSiblingNixosDirs = importSubdirs "nixos.nix";

  importSubdirs =
    file: dir:
    lib.pipe dir [
      listFilesRecursive
      (filter (path: baseNameOf path == "${file}"))
      (filter (path: path != /.${dir}/${file}))
    ];

  recurseFirstMatching =
    file: dir:
    let
      items = readDir dir;
    in
    if items ? ${file} && items.${file} == "regular" then
      [ /.${dir}/${file} ]
    else
      foldlAttrs (
        acc: name: type:
        if type == "directory" then acc ++ importModules file /.${dir}/${name} else acc
      ) [ ] items;

  importHmModules = recurseFirstMatching "default.nix";
  importNixosModules = recurseFirstMatching "nixos.nix";
  importNixDarwinModules = recurseFirstMatching "nix-darwin.nix";
in
{
  inherit
    importHmModules
    importNixDarwinModules
    importNixosModules
    importSiblingNixDarwinDirs
    importSiblingNixosDirs
    importSiblings
    importSubdirs
    mkCopyActivationScript
    recurseFirstMatching
    recursiveMap
    setCaskHash
    ;

}
