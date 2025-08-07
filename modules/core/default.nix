{
  flags,
  lib,
  inputs,
  config,
  pkgs,
  util,
  ...
}:
util.mkModule {
  shared.imports = [ ./fontconfig ];

  hm = {
    home = {
      inherit (config.gipphe) username homeDirectory;
      # NO TOUCHY!
      stateVersion = "23.11";
      sessionVariables = {
        NH_FLAKE = "${config.home.homeDirectory}/projects/dotfiles";
        # Help dynamically linked libraries and other libraries depending upon the
        # c++ stdenv find their stuff
        # LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
      };
      packages = lib.optionals (!flags.isNixOnDroid) [ pkgs.xdg-utils ];
    };

    # Manage home-manager executable
    programs.home-manager.enable = true;

    # Manage XDG directories and configs
    xdg.enable = true;
  };

  system-nixos = {
    documentation.dev.enable = false;

    # Auto-upgrading with nixos-unstable is risky
    system.autoUpgrade.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = lib.mkDefault "23.11"; # Did you read the comment?
  };

  system-darwin = {
    imports = [ inputs.mac-app-util.darwinModules.default ];

    # Need to have zsh to do much on darwin
    programs.zsh.enable = true;

    # Set Git commit hash for darwin-version.
    system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;

    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";
  };

  system-droid = {
    # Read the changelog before changing this value
    system.stateVersion = "24.05";
  };
}
