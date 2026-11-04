{
  den.aspects.programs.claude-code.skills.cardano-search.homeManager = { pkgs, ... }: {
    home.file.".claude/skills/cardano-search".source = pkgs.callPackage ./_skill.nix { };
  };
}
