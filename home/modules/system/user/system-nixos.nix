{ config, lib, ... }:
let
  inherit (config.gipphe) username homeDirectory;
in
{
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
}
