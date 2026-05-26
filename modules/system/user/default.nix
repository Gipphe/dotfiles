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

  nixos = {
    users.users.${username} = {
      uid = lib.mkDefault 1010;
      isNormalUser = true;
      description = "Victor Nascimento Bakke";
      home = lib.mkDefault homeDirectory;
      group = username;
      extraGroups = [ "wheel" ];
    };

    users.groups.${username} = {
      gid = lib.mkDefault 1010;
    };
  };
}
