{
  config,
  lib,
  util,
  pkgs,
  ...
}:
let
  cfg = config.gipphe.programs.logseq;
  json = pkgs.formats.json { };
in
util.mkProgram {
  name = "logseq";
  options.gipphe.programs.logseq = {
    settings = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Global settings for the global config.end file. Written as edn.";
    };
    preferences = lib.mkOption {
      type = json.type;
      default = { };
      description = "General preferences";
    };
  };
  hm = {
    gipphe.programs.logseq = {
      preferences = {
        theme = null;
        themes = {
          mode = "dark";
          light = null;
          dark = {
            name = "Default Dark Theme";
            url = null;
            description = "Logseq default dark theme.";
            mode = "dark";
            selected = true;
            group-first = true;
            group-desc = "dark themes";
          };
        };
        externals = [ ];
      };
      settings = /* clojure */ ''
        {:meta/version 1
         :preferred-workflow :todo
         :start-of-week 0
         :feature/enable-block-timestamps? true
         :file/name-format :triple-lowbar
         :journal/page-title-format "yyyy-MM-dd EEEE"
         :editor/logical-outdenting? true
         :editor/preferred-pasting-file? true}
      '';
    };

    home = {
      packages = [ pkgs.logseq ];
      file.".logseq/config/config.edn" = {
        enable = cfg.settings != "";
        text = cfg.settings;
      };
      file.".logseq/preferences.json" = {
        enable = cfg.preferences != { };
        source = json.generate "logseq-preferences.json" cfg.preferences;
      };
    };
  };
}
