{ util, ... }:
util.mkProgram {
  name = "eza";
  hm.programs.eza = {
    enable = true;
    icons = true;
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}
