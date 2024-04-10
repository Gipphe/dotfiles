{ config, lib, ... }:
let
  cfg = config.gipphe.programs.zellij;
in
{
  options.gipphe.programs.zellij = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = !config.programs.tmux.enable;
    };
  };
  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "zellij/layouts".source = ./layouts;
      "zellij/config.kdl".source = ./config.kdl;
    };
    programs = {
      zellij.enable = true;

      fish = lib.mkIf config.programs.zellij.enable {
        shellAbbrs = {
          tmux = "zellij";
          mux = "zellij --layout";
          zq = "zellij kill-session $ZELLIJ_SESSION_NAME";
        };
      };
    };
  };
}
