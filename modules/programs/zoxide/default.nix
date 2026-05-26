{ util, ... }:
util.mkProgram {
  name = "zoxide";
  homeManager = {
    programs.zoxide = {
      enable = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
  };
}
