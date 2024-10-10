{ lib, pkgs, ... }:
let

  autolock = pkgs.fetchurl {
    url = "https://github.com/fresh2dev/zellij-autolock/releases/download/0.1.1/zellij-autolock.wasm";
    hash = "sha256-w0/tuThhDa+YaxqzUrGvovgZKNM+vSkQC7/FxmSWf8o=";
  };
  inherit (import ../helpers.nix { inherit lib; }) section bind;
in
{
  xdg.configFile."zellij/plugins/zellij-autolock.wasm".source = autolock;
  programs.zellij = {
    settings = {
      keybinds = (
        section "normal" (
          lib.mergeAttrsList [
            (bind "Enter" {
              WriteChars = "\\u{000D}";
              "MessagePlugin \"autolock\"" = { };
            })
            (bind "Ctrl r" {
              WriteChars = "\\u{0012}";
              "MessagePlugin \"autolock\"" = { };
            })
          ]
        )
      );

      plugins."autolock location=\"file:~/.config/zellij/plugins/zellij-autolock.wasm\"" = {
        triggers = "nvim|vim";
        watch_triggers = "fzf|zoxide|atuin";
        watch_interval = "1.0";
      };
    };
  };
}
