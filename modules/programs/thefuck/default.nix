{ util, ... }:
util.mkProgram {
  name = "thefuck";
  hm = {
    programs.thefuck.enable = true;
    xdg.configFile."thefuck/settings.py".text = # python
      ''
        priority = { "fix_file": 2000 }
      '';
  };
}
