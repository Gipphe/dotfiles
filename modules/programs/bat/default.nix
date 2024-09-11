{ util, ... }:
util.mkProgram {
  name = "bat";
  hm.programs = {
    fish.shellAbbrs.cat = "bat";
    bat.enable = true;
  };
}
