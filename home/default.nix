{ lib, stdenv, ... }:
with stdenv;
with lib;
let
  inherit (attrsets) filterAttrs;
  machineConfig = let
    thisMachine = readFile ../machineName;
    machineNames = filterAttrs (_: v: v == "directory") (readDir ./machines);
    machines = foldl' (l: m: l // { "${m}" = ./machines/${m}/default.nix; }) { }
      machineNames;
  in machines.${thisMachine};
in {
  imports = [
    ./packages
    ./programs
    # machineConfig 
  ];

  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;

  home = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = "gipphe";
    homeDirectory = "/home/gipphe";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    # You can also manage environment variables but you will have to manually
    # source
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/gipphe/etc/profile.d/hm-session-vars.sh
    #
    # if you don't want to manage your shell through Home Manager.
    sessionVariables = {
      EDITOR = "nvim";
      PAGER = "less -FXR";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      grabKeyboardAndMouse = false;
      pinentryFlavor = "curses";
      # enableSshSupport = true;
    };

    # ssh-agent.enable = true;
  };
}
