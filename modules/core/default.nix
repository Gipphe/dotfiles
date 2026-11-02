{ den, lib, ... }: {
  den.schema.host.imports = [
    {
      options.settings = lib.mkOption {
        type = import ./_settings-type.nix { inherit den lib; };
        default = { };
        description = "Per-aspect typed settings";
      };
    }
  ];

  den.schema.user = { user, lib, ... }: {
    imports = [
      {
        options.settings = lib.mkOption {
          type = import ./_settings-type.nix { inherit den lib; };
          default = { };
          description = "Per-aspect typed settings";
        };
      }
    ];
    options.homeDirectory = lib.mkOption {
      description = "Path to home directory for the user";
      type = lib.types.str;
      default = "/home/${user.userName}";
    };
    config.isStrict = true;
    config.includes = [ den.batteries.host-aspects ];
  };
  den.schema.host.isStrict = true;
  den.schema.home.isStrict = true;
  den.reservedKeys = [ "settings" ];
  den.aspects.core = {
    # options.gipphe.core.xdg = {
    #   stateDir = lib.mkOption {
    #     type = lib.types.path;
    #     description = "Path to XDG_STATE_DIRS directory for own state";
    #     default = "${config.xdg.stateHome}/gipphe";
    #   };
    #   configDir = lib.mkOption {
    #     type = lib.types.path;
    #     description = "Path to XDG_CONFIG_DIRS directory for own config";
    #     default = "${config.xdg.configHome}/gipphe";
    #   };
    #   shareDir = lib.mkOption {
    #     type = lib.types.path;
    #     description = "Path to XDG_SHARE_DIRS directory for own shared files";
    #     default = "${config.xdg.shareHome}/gipphe";
    #   };
    # };

    nixos = { lib, ... }: {
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

    nixOnDroid = {
      # Read the changelog before changing this value
      system.stateVersion = "24.05";
    };
  };
}
