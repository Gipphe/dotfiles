{ pkgs, lib, ... }:
let
  zj-status-bar = pkgs.fetchurl {
    url = "https://github.com/cristiand391/zj-status-bar/releases/download/0.3.0/zj-status-bar.wasm";
    hash = "";

  };
in
{
  xdg.configFile = {
    "zellij/layouts/default.kdl".text = # kdl
      ''
        layout {
          pane size=1 {
            plugin location="file:~/.config/zellij/plugins/zj-status-bar.wasm"
          }
          pane
        }
      '';
    "zellij/plugins/zj-status-bar.wasm".source = zj-status-bar;
  };
  programs.fish.functions.zw = # fish
    ''
      eval "$argv"
      zellij pipe --name zj-status-bar:cli:tab_alert --args "pane_id=$ZELLIJ_PANE_ID,exit_code=$status"
    '';

}
