{ util, ... }:
util.mkProgram {
  name = "zoxide";
  home-manager = {
    programs.zoxide = {
      enable = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
  };
}
