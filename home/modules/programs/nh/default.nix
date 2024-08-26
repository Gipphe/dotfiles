{ util, ... }:
util.mkProgram {
  name = "nh";
  system-nixos.programs.nh = {
    enable = true;
    flake = "/home/gipphe/projects/dotfiles";
  };
}
