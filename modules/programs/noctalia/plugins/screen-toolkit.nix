{ den, inputs, ... }:
{
  den.aspects.programs.noctalia.plugins.screen-toolkit = {
    includes = builtins.attrValues {
      inherit (den.aspects.programs)
        curl
        ffmpeg
        gpu-screen-recorder
        imagemagick
        jq
        mpv
        wf-recorder
        ;
    };
    homeManager = { pkgs, ... }: {
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
      xdg.dataFile."noctalia/plugins/screen-toolkit".source =
        "${inputs.noctalia-community-plugins}/screen-toolkit";
    };
  };
}
