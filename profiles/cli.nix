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
      nix-pr-tracker.enable = true;
      vim.configOnly = true;
      vim.enable = true;
    };
  };
}
