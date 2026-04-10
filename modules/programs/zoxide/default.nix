{ util, ... }:
util.mkProgram {
  name = "zoxide";
  hm = {
    programs.zoxide = {
      enable = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
  };
}
