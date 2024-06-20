{
  lib,
  config,
  pkgs,
  flags,
  inputs,
  ...
}:
{
  options.gipphe.programs.slack.enable = lib.mkEnableOption "slack";
  config = lib.mkIf config.gipphe.programs.slack.enable (
    lib.mkMerge [
      (lib.mkIf flags.system.isNixos { home.packages = with pkgs; [ slack ]; })
      (lib.mkIf flags.system.isNixDarwin {
        home.packages = [ inputs.brew-nix.packages.${pkgs.system}.slack ];
      })
    ]
  );
}
