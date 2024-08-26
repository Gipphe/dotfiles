{
  lib,
  pkgs,
  util,
  ...
}:
let
  inherit (lib.attrsets) filterAttrs;
  inherit (builtins)
    readDir
    attrNames
    foldl'
    readFile
    ;
in
util.mkProgram {
  name = "tmux";

  hm = {
    home.file =
      let
        tmuxinator_dir_entries = readDir ./tmuxinator;
        tmuxinator_files = filterAttrs (_: type: type == "regular") tmuxinator_dir_entries;
        tmuxinator_file_names = attrNames tmuxinator_files;
        tmuxinator_configs = foldl' (
          acc: name: acc // { ".config/tmuxinator/${name}".source = ./tmuxinator/${name}; }
        ) { } tmuxinator_file_names;
      in
      tmuxinator_configs;
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      escapeTime = 10;
      mouse = true;
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [
        { plugin = sensible; }
        { plugin = vim-tmux-navigator; }
        { plugin = yank; }
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
