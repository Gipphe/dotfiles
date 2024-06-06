{ flags, ... }:
{
  users.users.${flags.username} = {
    home = flags.homeDirectory;
  };
}
