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
  pkgs' = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/ec0c722e017dfccbb2f66a8aafbe003320266d33.tar.gz";
    sha256 = "0jws2i94asr1yish76799gmyw51dj98n8badq3snc8prifmsd3a5";
  }) { system = pkgs.stdenv.hostPlatform.system; };
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
  homeManager = {
    gipphe.programs.logseq = {
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
      packages = [ pkgs'.logseq ];
      file.".logseq/config/config.edn" = {
        enable = cfg.settings != "";
        text = cfg.settings;
      };
    };
  };

  shared.gipphe.nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];
}
