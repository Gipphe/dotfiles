{ config, lib, ... }:
let
  forHost =
    hostnames: secretFile: secretName: extra:
    lib.mkIf (builtins.elem config.networking.hostName hostnames) {
      ${secretName} = {
        file = secretFile;
      } // extra;
    };
  user = {
    owner = "gipphe";
    group = "users";
  };
in
{
  age.secrets = lib.mkMerge [
    (forHost [ "Jarle" ] ../../secrets/syncthing-jarle-key.age "syncthing-jarle-key" user)
    (forHost [ "Jarle" ] ../../secrets/syncthing-jarle-cert.age "syncthing-jarle-cert" user)
    (forHost [
      "trond-arne"
    ] ../../secrets/syncthing-trond-arne-key.age "syncthing-trond-arne-key" user)
    (forHost [
      "trond-arne"
    ] ../../secrets/syncthing-trond-arne-cert.age "syncthing-trond-arne-cert" user)
  ];
}
