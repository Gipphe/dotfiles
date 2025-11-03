{
  util,
  inputs,
  pkgs,
  ...
}:
util.mkProgram {
  name = "barrier";
  hm.home.packages = [ inputs.brew-nix.packages.${pkgs.stdenv.hostPlatform.system}.barrier ];
}
