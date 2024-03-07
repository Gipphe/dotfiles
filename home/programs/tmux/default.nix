{ pkgs, lib, ... }:
with builtins;
with lib.attrsets; {
  home.file = let
    tmuxinator_configs = lib.pipe ./tmuxinator [
      readDir
      (filterAttrs (name: type: type == "regular"))
      attrNames
      (foldl' (acc: name:
        acc // {
          ".config/tmuxinator/${name}" = readFile ./tmuxinator/${name};
        }))
    ];
  in tmuxinator_configs;
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
      {
        plugin = pkgs.fetchFromGitHub {
          owner = "fabioluciano";
          repo = "tmux-tokyo-night";
          rev = "main";
          sha256 = lib.fakeHash;
        };
        extraConfig = ''
          set -g @theme_plugin_datetime_format '%a %F %k:%M:%S %Z'
        '';
      }
      { plugin = yank; }
    ];
    extraConfig = readFile ./tmux.conf;
    tmuxinator.enable = true;
  };
}
