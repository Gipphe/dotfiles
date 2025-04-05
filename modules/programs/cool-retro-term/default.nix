{
  inputs,
  lib,
  pkgs,
  util,
  ...
}:
let
  inherit (pkgs.stdenv) hostPlatform;
in
util.mkProgram {
  name = "cool-retro-term";
  hm.home.packages = [
    (lib.mkIf hostPlatform.isLinux pkgs.cool-retro-term)
    (lib.mkIf hostPlatform.isDarwin inputs.brew-nix.packages.${pkgs.system}.cool-retro-term)
  ];
}
