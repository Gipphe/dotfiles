{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.environment.desktop.hyprland.enable {
    fonts = {
      packages = with pkgs; [
        material-icons
        material-design-icons
        roboto
        work-sans
        comic-neue
        source-sans
        twemoji-color-font
        comfortaa
        inter
        lato
        lexend
        jost
        dejavu_fonts
        iosevka-bin
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        jetbrains-mono
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
      ];

      enableDefaultPackages = false;

      # this fixes emoji stuff
      fontconfig.defaultFonts = {
        monospace = [
          "Fira Code Nerd Font Mono"
          "Fira Code Nerd Font"
          "Fira Code"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Lexend"
          "Noto Color Emoji"
        ];
        serif = [
          "Noto Serif"
          "Noto Color emojo"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
