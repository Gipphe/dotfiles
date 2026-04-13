{ util, ... }:
let
  user_id = "ZRLJD6BOQZFFNF67FTJDPPJUE";
in
util.mkProgram {
  name = "_1password-cli";
  hm = {
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
      };
    };
  };

  system-nixos = {
    programs._1password.enable = true;
  };
}
