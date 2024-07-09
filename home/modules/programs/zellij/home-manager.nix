{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.zellij;
in
{
  config = lib.mkIf cfg.enable {
    home.file = {
      "zellij-plugins/zellij_forgot.wasm".source = pkgs.fetchurl {
        url = "https://github.com/karimould/zellij-forgot/releases/download/0.3.0/zellij_forgot.wasm";
        hash = "sha256-JNQ4KXb6VzjSF0O4J8Tvq3FXUYBBabQb9ZitcR3kZFw=";
      };
      "zellij-plugins/zjstatus.wasm".source = pkgs.fetchurl {
        url = "https://github.com/dj95/zjstatus/releases/download/v0.14.0/zjstatus.wasm";
        hash = "sha256-TlPnvSz1ROusMXP0CeQJcugR0RdiKTqwMxpUDiP0SRU=";
      };
    };
    xdg.configFile = {
      "zellij/layouts".source = ./layouts;
      "zellij/config.kdl".source = ./config.kdl;
    };
    programs = {
      zellij.enable = true;

      fish.shellAbbrs = {
        tmux = "zellij";
        mux = "zellij --layout";
        zq = "zellij kill-session $ZELLIJ_SESSION_NAME";
      };
    };
  };
}
