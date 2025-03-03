{
  util,
  pkgs,
  lib,
  inputs,
  ...
}:
util.mkProgram {
  name = "rider";
  hm = {
    home.packages = [
      (lib.mkIf pkgs.stdenv.isDarwin inputs.brew-nix.packages.${pkgs.system}.rider)
      (lib.mkIf pkgs.stdenv.isLinux pkgs.jetbrains.rider)
    ];
    gipphe.windows.profiles.titanium.chocolatey.programs = [ "jetbrains-rider" ];
  };
}
