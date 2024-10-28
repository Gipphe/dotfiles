{ util, ... }:
util.mkProgram {
  name = "eza";
  hm.programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}
