{ util, ... }:
util.mkProfile {
  name = "cli";
  shared.gipphe = {
    profiles.cli-slim.enable = true;
    programs = {
      _1password-cli.enable = true;
      ffmpeg.enable = true;
      imagemagick.enable = true;
      mprocs.enable = true;
      vim.enable = true;
      vim.configOnly = true;
    };
  };
}
