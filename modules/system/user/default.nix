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
      uid = 1010;
      isNormalUser = true;
      description = "Victor Nascimento Bakke";
      home = lib.mkDefault homeDirectory;
      group = username;
      extraGroups = [ "wheel" ];
    };

    users.groups.${username} = {
      gid = 1010;
    };
  };
}
