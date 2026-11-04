{ den, ... }:
{
  den.aspects.profiles.nixos.camera.includes = [
    den.aspects.system.camera
  ];
}
