{
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
      {
        name = "intellij-idea";
        args.no_binaries = true;
      }
      "karabiner-elements"
      "linearmouse"
      "logi-options-plus"
      "neo4j"
      "notion"
      "obsidian"
      "openvpn-connect"
      "slack"
      "spotify"
      "xnviewmp"
    ];
  };
}
