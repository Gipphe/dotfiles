{ util, pkgs, ... }:
util.mkProgram {
  name = "openconnect";
  hm.home.packages = with pkgs; [
    openconnect
    networkmanager-openconnect
    openconnect_gnutls
  ];
}
