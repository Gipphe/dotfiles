{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.barrier.enable {
    home.packages = [ inputs.brew-nix.packages.${pkgs.system}.barrier ];
  };
}
