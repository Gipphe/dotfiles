{
  lib,
  pkgs,
  inputs,
  util,
  ...
}:
let
  inherit (pkgs.stdenv) hostPlatform;
in
util.mkProgram {
  name = "obsidian";
  hm = lib.mkMerge [
    (lib.mkIf hostPlatform.isLinux { home.packages = [ pkgs.obsidian ]; })
    (lib.mkIf hostPlatform.isDarwin {
      home.packages = [ inputs.brew-nix.packages.${pkgs.system}.obsidian ];
    })
  ];
}
