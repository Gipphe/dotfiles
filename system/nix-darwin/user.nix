{ flags, ... }:
{
  users.users.${flags.user.username} = {
    home = flags.user.homeDirectory;
  };
}
