{
  util,
  inputs,
  pkgs,
  ...
}:
util.mkGaming {
  name = "fluorine-manager";
  homeManager.home.packages = [
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.fluorine-manager
  ];
}
