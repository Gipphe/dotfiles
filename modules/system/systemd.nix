{
  den.aspects.system.systemd.nixos =
    { options, ... }:
    let
      # `systemd.settings` and `systemd.user.settings` only exist in newer
      # nixpkgs. Hosts built with an older one (e.g. sodium, via
      # nixos-raspberrypi) use `extraConfig`.
      timeouts =
        (
          if options.systemd ? settings then
            { settings.Manager.DefaultTimeoutStopSec = "16s"; }
          else
            { extraConfig = "DefaultTimeoutStopSec=16s"; }
        )
        // {
          user =
            if options.systemd.user ? settings then
              { settings.Manager.DefaultTimeoutStopSec = "16s"; }
            else
              { extraConfig = "DefaultTimeoutStopSec=16s"; };
        };
    in
    {
      # Kills the highest-badness process as soon as free memory drops below the
      # threshold, before the system becomes unresponsive. Much faster than
      # systemd-oomd alone.
      services.earlyoom = {
        enable = true;
        freeMemThreshold = 5;
        freeSwapThreshold = 5;
        enableNotifications = true;
      };

      systemd = timeouts // {
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
