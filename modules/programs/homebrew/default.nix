{ util, ... }:
util.mkProgram {
  name = "homebrew";
  system-darwin.homebrew.enable = true;
}
