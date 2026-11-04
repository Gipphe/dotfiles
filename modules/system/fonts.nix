{
  den.aspects.system.fonts = {
    homeManager = { pkgs, ... }: {
      fonts.fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [ "FiraCode Nerd Font Mono" ];
          sansSerif = [ "Noto Sans" ];
          serif = [ "Noto Serif" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
      home.packages = [
        pkgs.noto-fonts
        pkgs.nerd-fonts.fira-code
        pkgs.noto-fonts-color-emoji
      ];
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
