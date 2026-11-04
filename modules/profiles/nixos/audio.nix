{ den, ... }:
{
  den.aspects.profiles.nixos.audio.includes = [
    den.aspects.programs.pipewire
  ];
}
