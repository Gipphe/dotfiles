{ util, lib, ... }:
{
  imports =
    util.recurseFirstMatching "default.nix" ./.
    ++ lib.filesystem.listFilesRecursive ./profiles;
}
