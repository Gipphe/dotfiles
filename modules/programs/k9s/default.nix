{ util, ... }:
util.mkProgram {
  name = "k9s";
  home-manager.programs.k9s.enable = true;
}
