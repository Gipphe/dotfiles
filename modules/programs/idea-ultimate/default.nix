{ util, ... }:
util.mkProgram {
  name = "idea-ultimate";

  homeManager.imports = [
    ./idea.nix
    ./config.nix
  ];
}
