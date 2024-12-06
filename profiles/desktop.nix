{ util, ... }:
util.mkProfile "desktop" {
  gipphe = {
    programs = {
      _1password-gui.enable = true;
      appimage.enable = true;
      code-cursor.enable = true;
      cool-retro-term.enable = true;
      # appImage wrapping breaking change.
      filen.enable = false;
      floorp.enable = true;
      gimp.enable = true;
      hoppscotch.enable = true;
      logseq.enable = true;
      obsidian.enable = true;
      slack.enable = true;
      wezterm.enable = true;
    };
  };
}
