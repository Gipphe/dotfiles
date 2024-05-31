{
  inputs,
  lib,
  flags,
  ...
}:
{
  config = lib.optionalAttrs flags.nix-darwin {
    import = [
      inputs.home-manager.darwinModules.home-manager
      ./rice.nix
      ./homebrew.nix
      ./nix.nix
    ];

    programs.zsh.enable = true;

    # Set Git commit hash for darwin-version.
    # system.configurationRevision = self.rev or self.dirtyRev or null;
  };
}
