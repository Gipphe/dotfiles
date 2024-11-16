{ util, pkgs, ... }:
util.mkProgram {
  name = "floorp";
  hm.programs.floorp = {
    enable = true;
    profiles = {
      default = {
        search = (import ../firefox/common.nix { inherit pkgs; }).search;
      };
    };
  };
}
