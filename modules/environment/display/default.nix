{
  config,
  pkgs,
  util,
  ...
}:
util.mkEnvironment {
  name = "display";
  system-nixos = {
    displayManager = {
      sddm.enable = true;
      # Enable automatic login for the user.
      autoLogin = {
        enable = true;
        user = config.gipphe.username;
      };
    };
    dbus.packages = [ pkgs.gcr ];

    # Workaround for GNOME autologin issue
    systemd.services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };
}
