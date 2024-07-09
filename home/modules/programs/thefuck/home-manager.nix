{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.thefuck.enable {
    programs.thefuck.enable = true;
    programs.thefuck.package = inputs.nixpkgs-master.legacyPackages.${pkgs.system}.thefuck;
  };
}
