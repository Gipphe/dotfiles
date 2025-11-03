{
  util,
  self,
  pkgs,
  ...
}:
util.mkProgram {
  name = "jdenticon-cli";
  hm.home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.jdenticon-cli ];
}
