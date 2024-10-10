{ util, ... }:
util.mkProgram {
  name = "thefuck";
  hm = {
    programs.thefuck.enable = true;
    xdg.configFile."thefuck/settings.py".text = # python
      ''
        exclude_rules = ["fix_file"]
      '';
  };
}
