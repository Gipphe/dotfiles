{
  lib,
  fetchFromGitHub,
  linkFarm,
  symlinkJoin,
  writeTextFile,
}:
let
  inherit (builtins) listToAttrs readFile;
  inherit (lib) pipe;

  skill = writeTextFile {
    name = "claude-code-skill-cardano-search.md";
    text = readFile ./SKILL.md;
    destination = "/SKILL.md";
  };
  repoDefs = [
    {
      owner = "IntersectMBO";
      repo = "cardano-api";
      rev = "034d1d7eee86be409a51309ba5fa1a788879928a";
      hash = "sha256-/xFrz/qTtkJUFfyZ5wSJ99TBj0xAFhuICmjVhqFe6k0=";
    }
    {
      owner = "IntersectMBO";
      repo = "cardano-base";
      rev = "db52f43b38ba5d8927feb2199d4913fe6c0f974d";
      hash = "sha256-/xFrz/qTtkJUFfyZ5wSJ99TBj0xAFhuICmjVhqFe6k0=";
    }
    {
      owner = "IntersectMBO";
      repo = "cardano-ledger";
      rev = "b5d3b4b1638af928830a629fdcd950640fac3334";
      hash = "sha256-B1eFCvT9K25XdTaLc3pLvnywR93GgjR8Z8B7T2SRttw=";
    }
    {
      owner = "IntersectMBO";
      repo = "cardano-node";
      rev = "10051dec74b21ff042b00e25239eb00fcbfc5556";
      hash = "sha256-NY7ki0xkgD7W86NKuqwundTPpNmRh7u9px5eUb6FerU=";
    }
    {
      owner = "IntersectMBO";
      repo = "ouroboros-consensus";
      rev = "3d32643b7fa46db63ff82fdac2c50c23584e839e";
      hash = "sha256-lhBS68tbV0yFtrCTsW3Jk0xbnDUq90+WI0nsEHSH+Q0=";
    }
    {
      owner = "IntersectMBO";
      repo = "ouroboros-network";
      rev = "38894b286110f5f4548c960d6a2652c2b9cdf53d";
      hash = "sha256-YLQxPAxX2esr5v471+rTS8MA2eoE4nUFEgt6/r2Zlmw=";
    }
  ];
  repoDrvs = map (
    r:
    fetchFromGitHub {
      inherit (r)
        owner
        repo
        rev
        hash
        ;
    }
  ) repoDefs;
  repos = pipe repoDrvs [
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
