{ util, ... }:
util.mkProgram {
  name = "eza";
  home-manager.programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}
