{
  inputs,
  util,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    ;
  inherit (import ./common.nix { inherit pkgs; })
    bangs
    search
    settings
    userChrome
    ;
in
util.mkProgram {
  name = "firefox";
  options.gipphe.programs.firefox = {
    installs = mkOption {
      description = "Installations that share the default Firefox config path.";
      default = { };
      type =
        with types;
        attrsOf (submodule {
          options = {
            defaultProfile = mkOption {
              description = "Name of default profile for the installation.";
              type = with types; nullOr str;
              default = null;
            };
            locked = mkOption {
              description = "Locked. Not sure what this does.";
              type = types.bool;
              default = true;
            };
          };
        });
    };
  };
  shared.imports = [ ./windows.nix ];
  hm = lib.mkMerge [
    (lib.mkIf pkgs.stdenv.isDarwin {
      home.packages = [ inputs.brew-nix.packages.${pkgs.system}.firefox ];
    })
    (lib.mkIf pkgs.stdenv.isLinux {
      programs.firefox = {
        enable = true;
        profiles = {
          default = {
            inherit search settings userChrome;
            name = "Default";
            id = 0;
            isDefault = true;
            bookmarks = [bangs] ++ import ./bookmarks/default.nix;
            containers = {
              Work = {
                id = 10;
                color = "orange";
                icon = "briefcase";
              };
            };
            containersForce = true;
          };
          strise = {
            inherit search settings userChrome;
            id = 1;
            name = "Strise";
            bookmarks = [bangs] ++ import ./bookmarks/strise.nix; };
          };
        };
      };
    })
  ];
}
