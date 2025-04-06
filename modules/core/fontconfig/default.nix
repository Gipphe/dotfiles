{
  lib,
  util,
  flags,
  pkgs,
  ...
}:
util.mkToggledModule [ "core" ] {
  name = "fontconfig";
  hm = {
    fonts.fontconfig.enable = true;

    home.activation.copy-termux-font =
      let
        font = "${pkgs.nerd-fonts.fira-code}/share/fonts/truetype/NerdFonts/FiraCode/FiraCodeNerdFontMono-Regular.ttf";
      in
      lib.mkIf flags.isNixOnDroid (
        lib.hm.dag.entryAfter [ "filesChanged" ] ''
          run mkdir -p "$(dirname -- '${font}')"
          run cp '${font}' '.termux/font.ttf'
        ''
      );
  };
}
