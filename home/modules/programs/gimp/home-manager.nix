{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.gimp.enable {
    home.packages = [
      (lib.mkIf pkgs.stdenv.isLinux pkgs.gimp-with-plugins)
      (lib.mkIf pkgs.stdenv.isDarwin inputs.brew-nix.packages.${pkgs.system}.gimp)
    ];
  };
}
