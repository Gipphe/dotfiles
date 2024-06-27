{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.slack.enable (
    lib.mkMerge [
      (lib.mkIf pkgs.stdenv.isLinux { home.packages = with pkgs; [ slack ]; })
      (lib.mkIf pkgs.stdenv.isDarwin {
        home.packages = [ inputs.brew-nix.packages.${pkgs.system}.slack ];
      })
    ]
  );
}
