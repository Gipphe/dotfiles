{
  lib,
  config,
  inputs,
  flags,
  system,
  ...
}:
{
  config = lib.mkIf (config.gipphe.programs.notion.enable && flags.system.isNixDarwin) {
    home.packages = [ inputs.brew-nix.packages.${system}.notion ];
  };
}
