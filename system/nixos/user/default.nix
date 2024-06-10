{
  lib,
  config,
  flags,
  ...
}:
let
  inherit (flags.user) username homeDirectory;
in
{
  imports = [ ./programs.nix ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "Victor Nascimento Bakke";
    home = lib.mkDefault homeDirectory;
    group = username;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  users.groups.${username} = { };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin = lib.mkIf config.services.xserver.enable {
    enable = true;
    user = username;
  };

  # Workaround for GNOME autologin issue
  systemd.services = lib.mkIf config.services.xserver.enable {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };

  services.gnome.gnome-keyring.enable = true;
}
