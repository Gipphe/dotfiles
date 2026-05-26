{
  util,
  self,
  pkgs,
  ...
}:
util.mkProgram {
  name = "jdenticon-cli";
  homeManager.home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.jdenticon-cli ];
}
