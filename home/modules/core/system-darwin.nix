{ inputs, config, ... }:
{
  imports = [ inputs.mac-app-util.darwinModules.default ];

  # home-manager.users.${config.gipphe.username}.imports = [
  #   inputs.mac-app-util.homeManagerModules.default
  # ];

  # Need to have zsh to do much on darwin
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
