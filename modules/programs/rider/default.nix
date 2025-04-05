{
  util,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (pkgs.stdenv) hostPlatform;
in
util.mkProgram {
  name = "rider";
  hm = {
    home.packages = [
      (lib.mkIf hostPlatform.isDarwin inputs.brew-nix.packages.${pkgs.system}.rider)
      (lib.mkIf hostPlatform.isLinux pkgs.jetbrains.rider)
    ];
    gipphe.windows.chocolatey.programs = [ "jetbrains-rider" ];
  };
}
