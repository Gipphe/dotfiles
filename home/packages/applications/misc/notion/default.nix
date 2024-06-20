{
  lib,
  config,
  inputs,
  flags,
  system,
  ...
}:
{
  options.gipphe.programs.notion.enable = lib.mkEnableOption "notion";
  config = lib.mkIf (config.gipphe.programs.notion.enable && flags.system.isNixDarwin) {
    home.packages = [ inputs.brew-nix.packages.${system}.notion ];
  };
}
