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
    home.packages = [ inputs.nixpkgs-before-rust-1-80-breaking.legacyPackages.${pkgs.system}.jnv ];
  };
}
