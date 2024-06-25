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
      (lib.mkIf lib.isLinux { home.packages = with pkgs; [ slack ]; })
      (lib.mkIf lib.isDarwin { home.packages = [ inputs.brew-nix.packages.${pkgs.system}.slack ]; })
    ]
  );
}
