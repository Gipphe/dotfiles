{ pkgs, util, ... }:
let
  inherit (builtins) readFile;
in
util.mkProgram {
  name = "tmux";

  hm = {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      escapeTime = 10;
      mouse = true;
      keyMode = "vi";
      plugins = [
        { plugin = pkgs.tmuxPlugins.sensible; }
        { plugin = pkgs.tmuxPlugins.vim-tmux-navigator; }
        { plugin = pkgs.tmuxPlugins.yank; }
      ];
      extraConfig = readFile ./tmux.conf;
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
