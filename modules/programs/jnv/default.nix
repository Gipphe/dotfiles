{
  util,
  pkgs,
  ...
}:
util.mkProgram {
  name = "jnv";
  home-manager.home.packages = [ pkgs.jnv ];
}
