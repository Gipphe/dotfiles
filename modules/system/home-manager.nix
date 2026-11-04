{ inputs, ... }:
let
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup-before-nix";
  };
in
{

  den.aspects.system.home-manager = {
    homeManager = { user }: { pkgs, ... }: {
      home = {
        username = user.userName;
        # NO TOUCHY!
        stateVersion = "23.11";
        sessionVariables = {
          NH_FLAKE = "${user.homeDirectory}/projects/dotfiles";
          # Help dynamically linked libraries and other libraries depending upon the
          # c++ stdenv find their stuff
          # This broke Hyprland in commit af855fa, and the root cause was found
          # and resolved in 41d13c6.
          # LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
        };
        packages = [ pkgs.xdg-utils ];
      };

      # Manage home-manager executable
      programs.home-manager.enable = true;
    };
    nixos = {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      inherit home-manager;
    };

    nixOnDroid = {
      inherit home-manager;
    };
  };
}
