{ pkgs, util, ... }:
util.mkProgram {
  name = "memcached";
  homeManager.home.packages = [ pkgs.memcached ];
}
