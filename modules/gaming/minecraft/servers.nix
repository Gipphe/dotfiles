{
  lib,
  util,
  inputs,
  config,
  ...
}:
let
  cfg = config.gipphe.gaming.minecraft.servers;
in
util.mkToggledModule [ "gaming" "minecraft" ] {
  name = "servers";
  options.gipphe.gaming.minecraft.servers.dataDir = lib.mkOption {
    type = lib.types.str;
    default = "/srv/minecraft";
    description = "Location to store server data";
  };
  shared.imports = [
    ./worlds/poketards.nix
  ];
  nixos = {
    imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
    services.minecraft-servers = {
      enable = true;
      eula = true;
      dataDir = cfg.dataDir;
    };
    users.users.${config.gipphe.username}.extraGroups = [ config.services.minecraft-servers.group ];
  };
}
