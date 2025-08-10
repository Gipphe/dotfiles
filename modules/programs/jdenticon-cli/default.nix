{
  util,
  self,
  pkgs,
  ...
}:
util.mkProgram {
  name = "jdenticon-cli";
  hm.home.packages = [ self.packages.${pkgs.system}.jdenticon-cli ];
}
