{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.gipphe = {
      isNormalUser = true;
      description = "Victor Nascimento Bakke";
      home = lib.mkDefault "/home/gipphe";
      group = "gipphe";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [
        firefox
        vivaldi
        _1password-gui
        #  thunderbird
      ];
    };

    users.groups.gipphe = { };

    # Enable automatic login for the user.
    services.xserver.displayManager.autoLogin = lib.mkIf config.services.xserver.enable {
      enable = true;
      user = "gipphe";
    };

    # Workaround for GNOME autologin issue
    systemd.services = lib.mkIf config.services.xserver.enable {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };

    services.gnome.gnome-keyring.enable = true;
  };
}
