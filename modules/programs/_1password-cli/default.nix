{ util, pkgs, ... }:
util.mkProgram {
  name = "_1password-cli";
  hm.home.packages = with pkgs; [ _1password-cli ];
}
