{ util, ... }:
util.mkProgram {
  name = "eza";
  homeManager.programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}
