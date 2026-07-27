{ util, ... }:
util.mkProgram {
  name = "_1password-cli";
  nixos = {
    programs._1password.enable = true;
  };
}
