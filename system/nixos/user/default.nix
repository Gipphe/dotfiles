{
  pkgs,
  lib,
  config,
  flags,
  ...
}:
{
  config = {
    imports = [ ./programs.nix ];

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${flags.username} = {
      isNormalUser = true;
      description = "Victor Nascimento Bakke";
      home = lib.mkDefault flags.homeDirectory;
      group = flags.username;
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

    users.groups.${flags.username} = { };

    # Enable automatic login for the user.
    services.xserver.displayManager.autoLogin = lib.mkIf config.services.xserver.enable {
      enable = true;
      user = flags.username;
    };

    # Workaround for GNOME autologin issue
    systemd.services = lib.mkIf config.services.xserver.enable {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };

    services.gnome.gnome-keyring.enable = true;
  };
}
