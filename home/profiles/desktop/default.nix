{ lib, config, ... }:
{
  options.gipphe.profiles.desktop.enable = lib.mkEnableOption "desktop profile";
  config = lib.mkIf config.gipphe.profiles.desktop.enable {
    gipphe = {
      programs = {
        _1password-gui.enable = true;
        cool-retro-term.enable = true;
        cyberduck.enable = true;
        filen.enable = true;
        gimp.enable = true;
        kitty.enable = true;
        obsidian.enable = true;
        slack.enable = true;
        vivaldi.enable = true;
        wezterm.enable = true;
      };
      environment = {
        theme.catppuccin.enable = true;
        wallpaper.small-memory.enable = true;
      };
    };
  };
}
