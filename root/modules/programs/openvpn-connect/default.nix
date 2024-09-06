{ util, ... }:
util.mkProgram {
  name = "openvpn-connect";
  system-darwin.homebrew.casks = [ "openvpn-connect" ];
}
