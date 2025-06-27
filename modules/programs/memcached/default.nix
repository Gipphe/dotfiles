{ pkgs, util, ... }:
util.mkProgram {
  name = "memcached";
  hm.home.packages = [ pkgs.memcached ];
}
