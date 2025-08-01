{ util, lib, ... }:
util.mkProfile {
  name = "application";
  shared.gipphe = {
    programs = {
      _1password-gui.enable = true;
      appimage.enable = true;
      cool-retro-term.enable = true;
      filen-desktop.enable = true;
      floorp.default = lib.mkDefault true;
      floorp.enable = true;
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
      wezterm.default = lib.mkDefault true;
      wezterm.enable = true;
    };
  };
}
