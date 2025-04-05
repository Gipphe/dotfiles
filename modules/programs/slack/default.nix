{
  lib,
  pkgs,
  util,
  inputs,
  ...
}:
let
  inherit (pkgs.stdenv) hostPlatform;
in
util.mkProgram {
  name = "slack";

  hm.config = lib.mkMerge [
    (lib.mkIf hostPlatform.isLinux { home.packages = with pkgs; [ slack ]; })
    (lib.mkIf hostPlatform.isDarwin {
      home.packages = [ inputs.brew-nix.packages.${pkgs.system}.slack ];
    })
  ];
}
