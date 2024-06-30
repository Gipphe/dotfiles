{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gipphe.environment.desktop.plasma.enable {
    services = {
      xserver = {
        # Enable the X11 windowing system.
        enable = true;

        # Enable the Plasma (KDE) Desktop Environment.
        displayManager.sddm.enable = true;
        desktopManager.plasma5.enable = true;
      };

      dbus.packages = lib.mkIf config.gipphe.system.dbus.enable [ pkgs.gcr ];

      # Enable automatic login for the user.
      xserver.displayManager.autoLogin = {
        enable = true;
        user = config.gipphe.username;
      };
    };
    # Workaround for GNOME autologin issue
    systemd.services = lib.mkIf config.gipphe.system.systemd.enable {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };
}
