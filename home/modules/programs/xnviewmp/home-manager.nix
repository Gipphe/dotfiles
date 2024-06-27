{
  lib,
  config,
  flags,
  utils,
  inputs,
  system,
  ...
}:
{
  config = lib.mkIf (config.gipphe.programs.xnviewmp.enable && flags.isNixDarwin) {
    home.packages = [
      (utils.setCaskHash inputs.brew-nix.packages.${system}.xnviewmp
        "sha256-TE87nserf+7TJRfuD1pKdEBg9QHNxyet06jrGlGRPGc="
      )
    ];
  };
}
