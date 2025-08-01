{ util, lib, ... }:
util.mkProfile {
  name = "strise-slim";
  shared.gipphe.programs = {
    google-cloud-sdk.enable = true;
    idea-ultimate.enable = true;
    kubectl.enable = true;
    kubectx.enable = true;
    gh.enable = true;
    gh.settings.aliases =
      let
        rocksTeamMembers = {
          "adrian" = "adriantr";
          "sivert" = "SivertRanden";
          "mathias" = "mattimoller";
          "sigurd" = "sberglann";
          "tom" = "tpot1";
        };
        teamMemberAliases = lib.mapAttrs' (name: username: {
          name = "add_${name}";
          value = "pr edit --add-reviewer ${username}";
        }) rocksTeamMembers;
      in
      {
        addorcks = "pr edit --add-reviewer strise/orcks";
      }
      // teamMemberAliases;
  };
}
