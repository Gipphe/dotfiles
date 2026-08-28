{
  util,
  inputs,
  pkgs,
  ...
}:
util.mkToggledModule [ "programs" "noctalia" "plugins" ] {
  name = "screen-toolkit";
  homeManager = {
    programs.noctalia.settings = {
      plugins.enabled = [ "alexander/screen-toolkit" ];
      widget.widget.type = "alexander/screen-toolkit:widget";
      plugin_settings."alexander/screen-toolkit" = {
        record-skip-confirmation = true;
        selected-ocr-lang = "eng+nor";
      };
    };
    home.packages = builtins.attrValues {
      inherit (pkgs)
        bc
        coreutils
        gpu-screen-recorder
        grim
        hyprpicker
        procps
        slurp
        swappy
        tesseract
        translate-shell
        xdg-utils
        zbar
        ;
    };
    gipphe.programs = {
      imagemagick.enable = true;
      curl.enable = true;
      jq.enable = true;
      ffmpeg.enable = true;
      mpv.enable = true;
      wf-recorder.enable = true;
    };
    xdg.dataFile."noctalia/plugins/screen-toolkit".source =
      "${inputs.noctalia-community-plugins}/screen-toolkit";
  };
}
