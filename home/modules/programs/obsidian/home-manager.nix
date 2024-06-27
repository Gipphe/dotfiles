{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.obsidian.enable (
    lib.mkMerge [
      (lib.mkIf pkgs.stdenv.isLinux { home.packages = [ pkgs.obsidian ]; })
      (lib.mkIf pkgs.stdenv.isDarwin {
        home.packages = [ inputs.brew-nix.packages.${pkgs.system}.obsidian ];
      })
    ]
  );
}
