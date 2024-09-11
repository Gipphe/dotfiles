{ util, lib, ... }:
{
  imports =
    util.recurseFirstMatchingIncludingSibling "default.nix" ./modules
    ++ util.recurseFirstMatchingIncludingSibling "default.nix" ./machines
    ++ lib.filesystem.listFilesRecursive ./profiles;
}
