{ lib, flags, ... }:
{
  config = lib.mkIf (flags.desktop.enable && flags.wayland) {
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
