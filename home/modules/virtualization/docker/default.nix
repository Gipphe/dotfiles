{ util, ... }:
util.mkToggledModule [ "virtualisation" ] {
  name = "docker";
  system-nixos.virtualisation.docker.enable = true;
  system-darwin.homebrew.casks = [ "docker" ];
}
