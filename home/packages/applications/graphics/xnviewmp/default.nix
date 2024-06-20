{
  lib,
  config,
  inputs,
  system,
  util,
  flags,
  ...
}:
{
  options.gipphe.programs.xnviewmp.enable = lib.mkEnableOption "xnviewmp";
  config = lib.mkIf (config.gipphe.programs.xnviewmp.enable && flags.system.isNixDarwin) {
    home.packages = [
      (util.setCaskHash inputs.brew-nix.packages.${system}.xnviewmp
        "sha256-TE87nserf+7TJRfuD1pKdEBg9QHNxyet06jrGlGRPGc="
      )
    ];
  };
}
