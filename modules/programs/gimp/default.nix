{
  lib,
  util,
  pkgs,
  inputs,
  ...
}:
let
  inherit (pkgs.stdenv) hostPlatform;
in
util.mkProgram {
  name = "gimp";

  hm.home.packages = [
    (lib.mkIf hostPlatform.isLinux pkgs.gimp-with-plugins)
    (lib.mkIf hostPlatform.isDarwin inputs.brew-nix.packages.${pkgs.system}.gimp)
  ];
}
