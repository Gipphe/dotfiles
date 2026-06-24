{ util, lib, ... }:
{
  imports =
    util.recurseFirstMatchingIncludingSibling "default.nix" ./modules
    ++ util.recurseFirstMatchingIncludingSibling "default.nix" ./hosts
    ++ lib.filesystem.listFilesRecursive ./profiles;
}
