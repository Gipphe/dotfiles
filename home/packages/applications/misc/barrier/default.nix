{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gipphe.programs.barrier.enable = lib.mkEnableOption "barrier";
  config = lib.mkIf config.gipphe.programs.barrier.enable {
    home.packages = [ inputs.brew-nix.packages.${pkgs.system}.barrier ];
  };
}
