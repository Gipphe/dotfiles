{
  util,
  pkgs,
  ...
}:
util.mkProgram {
  name = "jnv";
  hm.home.packages = [ pkgs.jnv ];
}
