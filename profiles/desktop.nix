{ util, ... }:
util.mkProfile "desktop" {
  gipphe = {
    programs = {
      _1password-gui.enable = true;
      appimage.enable = true;
      cool-retro-term.enable = true;
      filen-desktop.enable = true;
      floorp.enable = true;
      floorp.default = true;
      gimp.enable = true;
      gtk.enable = true;
      hoppscotch.enable = true;
      logseq.enable = true;
      mpris.enable = true;
      mpv.enable = true;
      obsidian.enable = true;
      qimgv.enable = true;
      signal.enable = true;
      slack.enable = true;
      spotify.enable = true;
      vivaldi.enable = true;
      wezterm.enable = true;
      wezterm.default = true;
    };
  };
}
