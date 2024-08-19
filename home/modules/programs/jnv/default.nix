{
  util,
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
util.mkProgram {
  name = "jnv";
  hm = lib.mkIf config.gipphe.programs.jnv.enable {
    home.packages = [ inputs.nixpkgs-agenix-not-broken.legacyPackages.${pkgs.system}.jnv ];
  };
}
