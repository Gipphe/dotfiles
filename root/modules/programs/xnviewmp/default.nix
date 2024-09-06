{
  lib,
  flags,
  inputs,
  pkgs,
  util,
  ...
}:
util.mkProgram {
  name = "xnviewmp";
  hm = lib.mkIf flags.isNixDarwin {
    home.packages = [
      (util.setCaskHash inputs.brew-nix.packages.${pkgs.system}.xnviewmp
        "sha256-TE87nserf+7TJRfuD1pKdEBg9QHNxyet06jrGlGRPGc="
      )
    ];
  };
}
