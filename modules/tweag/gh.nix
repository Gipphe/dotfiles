{ lib, ... }:
let
  teamMembers = {
    "christian" = "cgeorgii";
  };

  aliases = lib.mapAttrs' (name: username: {
    name = "add_${name}";
    value = "pr edit --add-reviewer ${username}";
  }) teamMembers;
in
{
  den.aspects.tweag.gh.homeManager.programs.gh.settings.aliases = aliases;
}
