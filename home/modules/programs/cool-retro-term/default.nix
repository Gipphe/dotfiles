{
  config,
  inputs,
  lib,
  pkgs,
  util,
  ...
}:
util.mkModule {
  options.gipphe.programs.cool-retro-term.enable = lib.mkEnableOption "cool-retro-term";
  hm = lib.mkIf config.gipphe.programs.cool-retro-term.enable {
    home.packages = [
      (lib.mkIf pkgs.stdenv.isLinux pkgs.cool-retro-term)
      (lib.mkIf pkgs.stdenv.isDarwin inputs.brew-nix.packages.${pkgs.system}.cool-retro-term)
    ];
  };
}
