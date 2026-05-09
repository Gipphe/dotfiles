{ util, ... }:
util.mkProgram {
  name = "idea-ultimate";

  home-manager.imports = [
    ./idea.nix
    ./config.nix
  ];
}
