{
  lib,
  config,
  inputs,
  system,
  utils,
  flags,
  ...
}:
{
  options.gipphe.programs.xnviewmp.enable = lib.mkEnableOption "xnviewmp";
  config = lib.mkIf (config.gipphe.programs.xnviewmp.enable && flags.system.isNixDarwin) {
    home.packages = [
      (utils.setCaskHash inputs.brew-nix.packages.${system}.xnviewmp
        "sha256-TE87nserf+7TJRfuD1pKdEBg9QHNxyet06jrGlGRPGc="
      )
    ];
  };
}
