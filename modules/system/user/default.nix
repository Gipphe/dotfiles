{
  lib,
  config,
  util,
  ...
}:
let
  inherit (config.gipphe) username homeDirectory;
in
util.mkToggledModule [ "system" ] {
  name = "user";

  system-nixos = {
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
    nix.settings.trusted-users = [ username ];

    users.groups.${username} = { };
  };
}
