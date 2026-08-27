{
  util,
  inputs,
  pkgs,
  ...
}:
util.mkToggledModule [ "programs" "noctalia" "plugins" ] {
  name = "screen-toolkit";
  homeManager = {
    programs.noctalia.settings.plugins.enabled = [ "alexander/screen-toolkit" ];
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
    gipphe.programs = {
      curl.enable = true;
      ffmpeg.enable = true;
      gpu-screen-recorder.enable = true;
      imagemagick.enable = true;
      jq.enable = true;
      mpv.enable = true;
      wf-recorder.enable = true;
    };
    xdg.dataFile."noctalia/plugins/screen-toolkit".source =
      "${inputs.noctalia-community-plugins}/screen-toolkit";
  };
}
