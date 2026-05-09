{
  util,
  self,
  pkgs,
  ...
}:
util.mkProgram {
  name = "jdenticon-cli";
  home-manager.home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.jdenticon-cli ];
}
