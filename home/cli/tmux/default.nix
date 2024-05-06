{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.gipphe.programs.tmux;
in
with builtins;
with lib.attrsets;
{
  options.gipphe.programs.tmux = {
    enable = lib.mkEnableOption "tmux" // {
      default = true;
    };
  };
  config = lib.mkIf cfg.enable {
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
      plugins = with pkgs; [
        { plugin = tmuxPlugins.sensible; }
        { plugin = tmuxPlugins.vim-tmux-navigator; }
        {
          plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
            pluginName = "tmux-tokyo-night";
            version = "unstable-2024-03-11";
            rtpFilePath = "tmux-tokyo-night.tmux";
            src = pkgs.fetchFromGitHub {
              owner = "fabioluciano";
              repo = "tmux-tokyo-night";
              rev = "ee73d4a9ba6222d7d51492a4e0e797c9249a879c";
              sha256 = "sha256-wWWxO6XNcfKO1TRxBhxd8lJLn7wIxyX4Fm1Nd2Rhbkw=";
            };
          };
          extraConfig = ''
            set -g @theme_plugin_datetime_format '%a %F %k:%M:%S %Z'
          '';
        }
        { plugin = tmuxPlugins.yank; }
      ];
      extraConfig = readFile ./tmux.conf;
      tmuxinator.enable = true;
    };
    programs.fish = {
      shellInit = ''
        if test -n "$TMUX"
            set -x DISABLE_AUTO_TITLE true
        end
      '';
      shellAbbrs = {
        mux = "tmuxinator s";
        zq = "tmux kill-session";
      };
    };
  };
}
