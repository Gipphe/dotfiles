{ util, ... }:
util.mkProgram {
  name = "ripgrep";
  home-manager.programs.ripgrep.enable = true;
}
