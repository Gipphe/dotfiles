{ lib, ... }:
{
  users = {
    users = {
      gipphe.uid = lib.mkForce 1001;
    };
    groups = {
      gipphe.gid = lib.mkForce 997;
      docker.gid = lib.mkForce 996;
    };
  };
}
