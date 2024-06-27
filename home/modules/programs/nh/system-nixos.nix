{ lib, config, ... }:
{
  config = lib.mkIf config.gipphe.programs.nh.enable {
    programs.nh = {
      enable = true;
      flake = "/home/gipphe/projects/dotfiles";
    };
  };
}
