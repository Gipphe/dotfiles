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
          desktopManager.plasma6.enable = true;
        };

        displayManager = {
          sddm.enable = true;
          # Enable automatic login for the user.
          autoLogin = {
            enable = true;
            user = config.gipphe.username;
          };
        };

        dbus.packages = [ pkgs.gcr ];
      };

      # Workaround for GNOME autologin issue
      systemd.services = {
        "getty@tty1".enable = false;
        "autovt@tty1".enable = false;
      };
    };
  }
