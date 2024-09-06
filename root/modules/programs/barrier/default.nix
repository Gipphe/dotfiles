{
  util,
  inputs,
  pkgs,
  ...
}:
util.mkProgram {
  name = "barrier";
  hm.home.packages = [ inputs.brew-nix.packages.${pkgs.system}.barrier ];
}
