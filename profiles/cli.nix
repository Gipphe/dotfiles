{ util, ... }:
util.mkProfile {
  name = "cli";
  shared.gipphe = {
    profiles.cli-slim.enable = true;
    programs = {
      _1password-cli.enable = true;
      asciinema-agg.enable = true;
      asciinema.enable = true;
      charm-freeze.enable = true;
      clipboard-jh.enable = true;
      ffmpeg.enable = true;
      imagemagick.enable = true;
      mprocs.enable = true;
      sd.enable = true;
      timg.enable = true;
      vhs.enable = true;
      vim.enable = true;
      vim.configOnly = true;
    };
  };
}
