{
  util,
  pkgs,
  ...
}:
util.mkProgram {
  name = "jnv";
  homeManager.home.packages = [ pkgs.jnv ];
}
