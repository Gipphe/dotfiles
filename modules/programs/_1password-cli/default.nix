{ util, pkgs, ... }:
let
  _1p = pkgs._1password-cli;
  user_id = "ZRLJD6BOQZFFNF67FTJDPPJUE";
in
util.mkProgram {
  name = "_1password-cli";
  hm = {
    home.packages = [ _1p ];
    programs.fish = {
      functions = {
        opon = # fish
          ''
            if test -z "$OP_SESSION_${user_id}"
              eval $(op signin)
            end
          '';
        opoff = # fish
          ''
            op signout
            set -e OP_SESSION_${user_id}
          '';
        pgppw = # fish
          ''
            op item get "PGP gipphe@gmail.com" --field label=password --reveal \
            | wl-copy --primary --trim-newline
          '';
      };
    };

  };
}
