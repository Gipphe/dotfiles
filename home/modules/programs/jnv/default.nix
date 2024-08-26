{
  util,
  inputs,
  pkgs,
  ...
}:
util.mkProgram {
  name = "jnv";
  hm.home.packages = [ inputs.nixpkgs-before-rust-1-80-breaking.legacyPackages.${pkgs.system}.jnv ];
}
