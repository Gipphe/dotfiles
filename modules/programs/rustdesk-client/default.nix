{ util, pkgs, ... }:
util.mkProgram {
  name = "rustdesk-client";
  hm = {
    home.packages = [ pkgs.rustdesk-flutter ];
  };
}
