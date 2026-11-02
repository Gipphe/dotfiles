{ den, ... }:
{
  den.aspects.profiles.cli.includes = [
    den.aspects.profiles.cli-slim
    den.aspects.programs._1password-cli
    den.aspects.programs.ffmpeg
    den.aspects.programs.imagemagick
    den.aspects.programs.mprocs
  ];
}
