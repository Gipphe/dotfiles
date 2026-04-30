{
  inputs,
  pkgs,
  util,
  ...
}:
let
  inherit (builtins) readFile;
in
util.mkProgram {
  name = "tmux";

  hm = {
    imports = [
      (inputs.wlib.lib.getInstallModule {
        name = "tmux";
        value = inputs.wlib.lib.wrapperModules.tmux;
      })
    ];
    wrappers.tmux = {
      enable = true;
      baseIndex = 1;
      paneBaseIndex = 1;
      terminalOverrides = ",xterm*:Tc";
      clock24 = true;
      escapeTime = 10;
      mouse = true;
      keyMode = "vi";
      plugins = [
        { plugin = pkgs.tmuxPlugins.sensible; }
        { plugin = pkgs.tmuxPlugins.vim-tmux-navigator; }
        { plugin = pkgs.tmuxPlugins.yank; }
      ];
      configAfter = readFile ./tmux.conf;
      tmuxinator.enable = true;
    };
    programs.fish = {
      shellInit = # fish
        ''
          if test -n "$TMUX"
              set -x DISABLE_AUTO_TITLE true
          end
        '';
      shellAbbrs = {
        mux = "tmuxinator s";
        tq = "tmux kill-session";
      };
    };
  };
}
