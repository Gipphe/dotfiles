{ lib, config, ... }:
let
  inherit (config.gipphe) username homeDirectory;
in
{
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

  services.gnome.gnome-keyring.enable = true;
}
