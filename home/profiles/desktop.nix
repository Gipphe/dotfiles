{ util, ... }:
util.mkProfile "desktop" {
  gipphe = {
    programs = {
      _1password-gui.enable = true;
      appimage.enable = true;
      cool-retro-term.enable = true;
      filen.enable = true;
      gimp.enable = true;
      logseq.enable = true;
      obsidian.enable = true;
      slack.enable = true;
      vivaldi.enable = true;
      wezterm.enable = true;
    };
  };
}
