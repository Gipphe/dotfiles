{
  util,
  self,
  pkgs,
  ...
}:
util.mkProgram {
  name = "bolt-launcher";
  hm.home.packages = [ self.packages.${pkgs.system}.bolt-launcher ];
}
