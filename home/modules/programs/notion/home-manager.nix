{
  lib,
  config,
  inputs,
  flags,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.gipphe.programs.notion.enable && flags.isNixDarwin) {
    home.packages = [ inputs.brew-nix.packages.${pkgs.system}.notion ];
  };
}
