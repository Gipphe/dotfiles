{ util, ... }:
util.mkProgram {
  name = "steam";
  hm.program.steam.enable = true;
  system-darwin.homebrew.casks = [ "steam" ];
}
