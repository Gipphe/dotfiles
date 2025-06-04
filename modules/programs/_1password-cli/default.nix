{ util, pkgs, ... }:
util.mkProgram {
  name = "_1password-cli";
  hm = {
    home.packages = with pkgs; [ _1password-cli ];
    programs.fish.shellAbbrs.pgpg = "op item get \"PGP gipphe@gmail.com\" --field label=password --reveal | wl-copy --primary --trim-newline";
  };
}
