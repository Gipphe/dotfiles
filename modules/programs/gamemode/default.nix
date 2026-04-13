{ util, ... }:
util.mkProgram {
  name = "gamemode";
  system-nixos = {
    programs.gamemode.enable = true;
  };
}
