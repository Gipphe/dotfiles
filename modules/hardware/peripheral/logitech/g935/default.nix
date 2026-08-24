{ util, pkgs, ... }:
util.mkToggledModule [ "hardware" "peripheral" "logitech" ] {
  name = "g935";
  nixos = {
    programs.solaar = {
      enable = true;
      userService.enable = true;
    };
    environment.systemPackages = [ pkgs.headsetcontrol ];
    services = {
      hardware.openrgb.enable = true;
      udev = {
        enable = true;
        packages = [ pkgs.headsetcontrol ];
      };
    };
    # Pin the G935 to ALSA card index 0: Wine's winealsa.drv (used by
    # proton-tkg, which lacks a native pipewire driver) always opens the
    # first-enumerated ALSA card as its default render endpoint, ignoring
    # PipeWire's default sink entirely. Without this, USB enumeration order
    # decides which card is 0, so games would randomly land on onboard/HDMI
    # audio instead of the headset.
    boot.extraModprobeConfig = ''
      options snd-usb-audio index=0 vid=0x046d pid=0x0a87
      options snd-hda-intel index=1,2
    '';
  };
}
