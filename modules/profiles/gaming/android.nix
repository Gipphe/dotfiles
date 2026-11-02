{ den, ... }:
{
  den.aspects.profiles.gaming.android.includes = [
    # Requires manual setup described here:
    # https://wiki.nixos.org/wiki/Waydroid
    den.aspects.programs.waydroid
  ];
}
