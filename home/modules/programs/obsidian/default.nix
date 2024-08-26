{
  lib,
  pkgs,
  inputs,
  util,
  ...
}:
util.mkProgram {
  name = "obsidian";
  hm = (
    lib.mkMerge [
      (lib.mkIf pkgs.stdenv.isLinux { home.packages = [ pkgs.obsidian ]; })
      (lib.mkIf pkgs.stdenv.isDarwin {
        home.packages = [ inputs.brew-nix.packages.${pkgs.system}.obsidian ];
      })
    ]
  );
}
