{
  util,
  inputs,
  pkgs,
  ...
}:
util.mkGaming {
  name = "mo2installer";
  homeManager.home.packages = [
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.mo2installer
  ];
}
