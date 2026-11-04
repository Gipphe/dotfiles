{ inputs, lib, ... }:
{
  den.aspects.gaming.minecraft.servers = {
    settings.dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/srv/minecraft";
      description = "Location to store server data";
    };
    nixos =
      { user, host }:
      { config, ... }:
      {
        imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
        services.minecraft-servers = {
          enable = true;
          eula = true;
          dataDir = host.settings.gaming.minecraft.servers.dataDir;
        };
        users.users.${user.userName}.extraGroups = [ config.services.minecraft-servers.group ];
      };
  };
}
