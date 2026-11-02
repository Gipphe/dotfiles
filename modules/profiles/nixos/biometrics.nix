{ den, ... }:
{
  den.aspects.profiles.nixos.biometrics.includes = [
    # Use fprintd-enroll to enroll finger prints
    den.aspects.system.fprint
  ];
}
