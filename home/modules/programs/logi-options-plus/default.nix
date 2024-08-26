{ util, ... }:
util.mkProgram {
  name = "logi-options-plus";
  system-darwin.homebrew.casks = [ "logi-options-plus" ];
}
