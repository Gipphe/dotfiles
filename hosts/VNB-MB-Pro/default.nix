{
  imports = [
    ../modules/nix/darwin.nix
    ./rice.nix
  ];
  environment.systemPackages = [ ];

  programs.zsh.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  homebrew = {
    enable = true;
    casks = [
      "1password"
      "alt-tab"
      "barrier"
      "cyberduck"
      "docker"
      "filen"
      "gimp"
      "jetbrains-toolbox"
      "karabiner-elements"
      "linearmouse"
      "logi-options-plus"
      "neo4j"
      "notion"
      "obsidian"
      "openvpn-connect"
      "phoenix-slides"
      "slack"
      "spotify"
      "vscodium"
    ];
  };
}
