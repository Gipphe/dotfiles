{
  lib,
  pkgs,
  util,
  inputs,
  ...
}:
util.mkProgram {
  name = "slack";

  hm.config = lib.mkMerge [
    (lib.mkIf pkgs.stdenv.isLinux { home.packages = with pkgs; [ slack ]; })
    (lib.mkIf pkgs.stdenv.isDarwin {
      home.packages = [ inputs.brew-nix.packages.${pkgs.system}.slack ];
    })
  ];
}
