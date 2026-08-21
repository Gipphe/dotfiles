{
  lib,
  fetchFromGitHub,
  linkFarm,
  symlinkJoin,
  writeTextFile,
}:
let
  inherit (builtins)
    listToAttrs
    readFile
    fromJSON
    attrValues
    ;
  inherit (lib) pipe;

  skill = writeTextFile {
    name = "claude-code-skill-cardano-search.md";
    text = readFile ./SKILL.md;
    destination = "/SKILL.md";
  };
  # Update this file with
  # , niv -s modules/programs/claude-code/skills/cardano-search/sources.json update
  repos = pipe ./sources.json [
    readFile
    fromJSON
    attrValues
    (map (
      r:
      fetchFromGitHub {
        inherit (r)
          owner
          repo
          rev
          sha256
          ;
      }
    ))
    (map (d: {
      name = "repos/${d.repo}";
      value = d;
    }))
    listToAttrs
    (linkFarm "cardano-repos")
  ];
in
symlinkJoin {
  name = "claude-code-skill-cardano-search";
  paths = [
    skill
    repos
  ];
}
