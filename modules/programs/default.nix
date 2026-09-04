{ lib, util, ... }: {
  imports =
    util.recurseFirstMatching "default.nix" ./.
    ++ lib.pipe ./. [
      builtins.readDir
      (lib.filterAttrs (_: type: type == "regular"))
    ];
}
