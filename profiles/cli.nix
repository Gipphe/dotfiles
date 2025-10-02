{ util, ... }:
util.mkProfile {
  name = "cli";
  shared.gipphe = {
    profiles.cli-slim.enable = true;
    programs = {
      _1password-cli.enable = true;
      clipboard-jh.enable = true;
      ffmpeg.enable = true;
      imagemagick.enable = true;
      mprocs.enable = true;
      sd.enable = true;
      vim.enable = true;
      vim.configOnly = true;
    };
  };
}
