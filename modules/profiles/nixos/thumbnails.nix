{ den, ... }:
{
  den.aspects.profiles.nixos.thumbnails.includes = [
    den.aspects.programs.tumbler
    den.aspects.system.thumbnails.image
    den.aspects.system.thumbnails.video
  ];
}
