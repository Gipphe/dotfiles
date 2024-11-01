{ util, ... }:
util.mkProgram {
  name = "steam";
  hm.programs.steam.enable = true;
  system-darwin.homebrew.casks = [ "steam" ];
}
