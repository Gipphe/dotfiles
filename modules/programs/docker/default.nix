{ util, ... }:
util.mkProgram {
  name = "docker";
  system-nixos.virtualisation.docker.enable = true;
  system-darwin.homebrew.casks = [ "docker" ];
}
