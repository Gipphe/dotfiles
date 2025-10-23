{ lib, ... }:
{
  enumerateMachines =
    path:
    lib.pipe path [
      builtins.readDir
      (lib.filterAttrs (_: t: t == "directory"))
      builtins.attrNames
      (builtins.map (x: {
        ${x} = import "${path}/${x}/host.nix";
      }))
      lib.mergeAttrsList
    ];
}
