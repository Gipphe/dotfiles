{
  inputs,
  lib,
  pkgs,
  util,
  ...
}:
util.mkProgram {
  name = "cool-retro-term";
  hm.home.packages = [
    (lib.mkIf pkgs.stdenv.isLinux pkgs.cool-retro-term)
    (lib.mkIf pkgs.stdenv.isDarwin inputs.brew-nix.packages.${pkgs.system}.cool-retro-term)
  ];
}
