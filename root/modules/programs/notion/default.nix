{
  util,
  lib,
  inputs,
  pkgs,
  flags,
  ...
}:
util.mkProgram {
  name = "notion";

  hm = lib.mkIf flags.isNixDarwin {
    home.packages = [ inputs.brew-nix.packages.${pkgs.system}.notion ];
  };
}
