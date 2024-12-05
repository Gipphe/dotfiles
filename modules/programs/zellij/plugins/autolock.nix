{
  config,
  lib,
  pkgs,
  ...
}:
let

  autolock = pkgs.fetchurl {
    url = "https://github.com/fresh2dev/zellij-autolock/releases/download/0.2.1/zellij-autolock.wasm";
    hash = "sha256-w0/tuThhDa+YaxqzUrGvovgZKNM+vSkQC7/FxmSWf8o=";
  };
  inherit (config.gipphe.lib.zellij)
    section
    bind
    ;
in
{
  xdg.configFile."zellij/plugins/zellij-autolock.wasm".source = autolock;
  programs.zellij = {
    settings = {
      load_plugins = [
        "autolock"
      ];
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
        triggers = "nvim";
        watch_triggers = "vim|fzf|zoxide|atuin|yazi|yy|less";
        watch_interval = "1.0";
      };
    };
  };
}
