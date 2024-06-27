{ config, ... }:
{
  users.users.${config.gipphe.username} = {
    home = config.gipphe.homeDirectory;
  };
}
