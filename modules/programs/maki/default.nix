{
  inputs,
  util,
  pkgs,
  ...
}:
util.mkProgram {
  name = "maki";
  homeManager.home.packages = [
    inputs.maki.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
