{
  flags,
  lib,
  config,
  pkgs,
  util,
  ...
}:
util.mkModule {
  shared.imports = [
    ./fontconfig
    ./wm.nix
  ];

  hm = {
    home = {
      inherit (config.gipphe) username homeDirectory;
      # NO TOUCHY!
      stateVersion = "23.11";
      sessionVariables = {
        NH_FLAKE = "${config.home.homeDirectory}/projects/dotfiles";
        # Help dynamically linked libraries and other libraries depending upon the
        # c++ stdenv find their stuff
        # This broke Hyprland in commit af855fa, and the root cause was found
        # and resolved in 41d13c6.
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

  system-droid = {
    # Read the changelog before changing this value
    system.stateVersion = "24.05";
  };
}
