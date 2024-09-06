{ util, ... }:
util.mkProgram {
  name = "idea-ultimate";

  hm.imports = [
    ./idea.nix
    ./config.nix
  ];
}
