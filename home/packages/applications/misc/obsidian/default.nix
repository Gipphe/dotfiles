{
  lib,
  config,
  flags,
  inputs,
  pkgs,
  ...
}:
{
  options.gipphe.programs.obsidian.enable = lib.mkEnableOption "obsidian";
  config = lib.mkIf config.gipphe.programs.obsidian.enable (
    lib.mkMerge [
      (lib.mkIf flags.system.isNixos { home.packages = [ pkgs.obsidian ]; })
      (lib.mkIf flags.system.isNixDarwin {
        home.packages = [ inputs.brew-nix.packages.${pkgs.system}.obsidian ];
      })
    ]
  );
}
