{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.vivaldi.enable {
    home.packages = [
      (lib.mkIf pkgs.stdenv.isLinux pkgs.vivaldi)
      # (lib.mkIf pkgs.stdenv.isDarwin inputs.brew-nix.packages.${pkgs.system}.vivaldi)
    ];
  };
}
