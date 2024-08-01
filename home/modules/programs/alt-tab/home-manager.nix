{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.programs.alt-tab.enable {
    home.packages = with inputs.brew-nix.packages.${pkgs.system}; [ alt-tab ];
  };
}
