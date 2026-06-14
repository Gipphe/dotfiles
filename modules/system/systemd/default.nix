{ util, ... }:
let
  settings = {
    Manager = {
      DefaultTimeoutStopSec = "16s";
    };
  };
in
util.mkToggledModule [ "system" ] {
  name = "systemd";
  nixos = {
    # Kills the highest-badness process as soon as free memory drops below the
    # threshold, before the system becomes unresponsive. Much faster than
    # systemd-oomd alone.
    services.earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 5;
      enableNotifications = true;
    };

    systemd = {
      inherit settings;
      user.settings.Manager.DefaultTimeoutStopSec = "16s";
      services = {
        "getty@tty1".enable = false;
        "autovt@tty1".enable = false;
        "getty@tty7".enable = false;
        "autovt@tty7".enable = false;
      };

      # Systemd OOMd
      # Fedora enables these options by default. See the 10-oomd-* files here:
      # https://src.fedoraproject.org/rpms/systemd/tree/acb90c49c42276b06375a66c73673ac3510255
      oomd = {
        enableRootSlice = true;
        enableUserSlices = true;
        enableSystemSlice = true;
      };
    };
  };
}
