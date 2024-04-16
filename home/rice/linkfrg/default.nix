{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.rice.linkfrg;
in
{
  options.gipphe.rice.linkfrg = {
    enable = lib.mkEnableOption "linkfrg";
  };

  config = lib.mkIf cfg.enable {
# https://github.com/linkfrg/dotfiles/wiki/Installation
    home.packages = with pkgs; [ ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.default;
      # systemd = {
      #   variables = [ "--all" ];
      #   extraCommands = [
      #     "systemctl --user stop graphical-session.target"
      #     "systemctl --user start hyprland-session.target"
      #   ];
      # };
    };
  };
}
