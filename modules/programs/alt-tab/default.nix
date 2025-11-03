{
  util,
  inputs,
  pkgs,
  ...
}:
util.mkProgram {
  name = "alt-tab";
  hm.home.packages = [ inputs.brew-nix.packages.${pkgs.stdenv.hostPlatform.system}.alt-tab ];
}
