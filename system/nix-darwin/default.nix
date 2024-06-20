{
  inputs,
  lib,
  flags,
  ...
}:
lib.optionalAttrs flags.system.isNixDarwin {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.mac-app-util.darwinModules.default
    ./rice.nix
    ./homebrew.nix
    ./nix.nix
    ./user.nix
    ../../home/nix-darwin.nix
  ];

  programs.zsh.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;
}
