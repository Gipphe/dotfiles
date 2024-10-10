{ lib, pkgs, ... }:
let
  zj_forgot = pkgs.fetchurl {
    url = "https://github.com/karimould/zellij-forgot/releases/download/0.3.0/zellij_forgot.wasm";
    hash = "sha256-JNQ4KXb6VzjSF0O4J8Tvq3FXUYBBabQb9ZitcR3kZFw=";
  };
  inherit (import ../helpers.nix { inherit lib; }) shared_except bind;
in
{
  xdg.configFile."zellij/plugins/zj_forgot.wasm".source = zj_forgot;
  programs = {
    zellij = {
      enable = true;

      settings.keybinds = (
        shared_except [ "locked" ] (
          bind "Ctrl y" {
            "LaunchOrFocusPlugin \"file:~/.config/zellij/plugins/zj_forgot.wasm\"".floating = true;
          }
        )
      );
    };
  };
}
