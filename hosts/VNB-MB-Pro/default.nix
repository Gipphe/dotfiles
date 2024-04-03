{ pkgs, ... }:
{
  imports = [ ../modules/nix/darwin.nix ];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ pkgs.vim ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  homebrew = {
    enable = true;
    casks = [
      "1password"
      "alt-tab"
      "barrier"
      "barrier"
      "cyberduck"
      "docker"
      "filen"
      "jetbrains-toolbox"
      "karabiner-elements"
      "linearmouse"
      "logi-options-plus"
      "logi-options-plus"
      "neo4j"
      "notion"
      "notion"
      "obsidian"
      "openvpn-connect"
      "openvpn-connect"
      "slack"
      "spotify"
      "vscodium"
    ];
  };
}
