{
  den.aspects.system.user.nixos =
    { user }:
    { lib, ... }:
    let
      inherit (user) userName homeDirectory;
    in
    {
      users.users.${userName} = {
        uid = lib.mkDefault 1010;
        isNormalUser = true;
        description = "Victor Nascimento Bakke";
        home = lib.mkDefault homeDirectory;
        group = userName;
        extraGroups = [ "wheel" ];
      };

      users.groups.${userName} = {
        gid = lib.mkDefault 1010;
      };
    };
}
