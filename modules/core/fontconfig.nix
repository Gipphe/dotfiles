{
  den.aspects.core.fontconfig = {
    homeManager = {
      fonts.fontconfig.enable = true;
    };

    termux-font = {
      homeManager = { lib, pkgs, ... }: {
        home.activation.copy-termux-font =
          let
            font = "${pkgs.nerd-fonts.fira-code}/share/fonts/truetype/NerdFonts/FiraCode/FiraCodeNerdFontMono-Regular.ttf";
          in
          lib.hm.dag.entryAfter [ "filesChanged" ] ''
            if ! test -e "$HOME/.termux/font.ttf"; then
              run mkdir -p "$HOME/.termux"
              run cp '${font}' "$HOME/.termux/font.ttf"
            fi
          '';
      };
    };
  };
}
