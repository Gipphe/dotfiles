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
      (lib.mkIf lib.isLinux { home.packages = [ pkgs.obsidian ]; })
      (lib.mkIf lib.isDarwin { home.packages = [ inputs.brew-nix.packages.${pkgs.system}.obsidian ]; })
    ]
  );
}
