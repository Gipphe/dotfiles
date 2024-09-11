{
  util,
  config,
  pkgs,
  ...
}:
util.mkToggledModule
  [
    "environment"
    "desktop"
  ]
  {
    name = "plasma";
    system-nixos = {
      services = {
        xserver = {
          # Enable the X11 windowing system.
          enable = true;

          # Enable the Plasma (KDE) Desktop Environment.
          displayManager.sddm.enable = true;
          desktopManager.plasma5.enable = true;
        };

        dbus.packages = [ pkgs.gcr ];

        # Enable automatic login for the user.
        xserver.displayManager.autoLogin = {
          enable = true;
          user = config.gipphe.username;
        };
      };

      # Workaround for GNOME autologin issue
      systemd.services = {
        "getty@tty1".enable = false;
        "autovt@tty1".enable = false;
      };
    };
  }
