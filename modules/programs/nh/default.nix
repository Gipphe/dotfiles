{ util, ... }:
util.mkProgram {
  name = "nh";
  nixos.programs.nh = {
    enable = true;
    flake = "/home/gipphe/projects/dotfiles";
  };
}
