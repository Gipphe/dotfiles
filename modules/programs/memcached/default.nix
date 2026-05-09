{ pkgs, util, ... }:
util.mkProgram {
  name = "memcached";
  home-manager.home.packages = [ pkgs.memcached ];
}
