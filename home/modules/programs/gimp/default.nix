{
  lib,
  util,
  pkgs,
  inputs,
  ...
}:
util.mkProgram {
  name = "gimp";

  hm.home.packages = [
    (lib.mkIf pkgs.stdenv.isLinux pkgs.gimp-with-plugins)
    (lib.mkIf pkgs.stdenv.isDarwin inputs.brew-nix.packages.${pkgs.system}.gimp)
  ];
}
