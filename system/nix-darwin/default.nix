{
  inputs,
  lib,
  flags,
  ...
}:
lib.optionalAttrs (flags.system == "nix-darwin") {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ./rice.nix
    ./homebrew.nix
    ./nix.nix
    ./user.nix
  ];

  programs.zsh.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;
}
