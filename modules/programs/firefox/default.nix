{
  inputs,
  util,
  lib,
  pkgs,
  ...
}:
let
  brewpkgs = inputs.brew-nix.packages.${pkgs.system};
  inherit (lib)
    mkOption
    types
    ;
  inherit (import ./common.nix { inherit pkgs; })
    bangs
    search
    settings
    userChrome
    installHashes
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
      home.packages = [ brewpkgs."firefox@developer-edition" ];
      programs.firefox.package = brewpkgs.firefox;
      gipphe.programs.firefox.installs = {
        ${installHashes.darwin.firefox}.defaultProfile = "default";
        ${installHashes.darwin.firefox-devedition}.defaultProfile = "strise";
      };
      home.file = {
        "Library/Application Support/Firefox/profiles.ini".source =
          pkgs.writeText "firefox-profiles.ini" # ini
            ''
              [Install69FE9373C2142565]
              Default=Profiles/default
              Locked=1

              [Profile4]
              Name=Strise
              IsRelative=1
              Path=Profiles/strise

              [Profile3]
              Name=Default
              IsRelative=1
              Path=Profiles/default

              [Profile2]
              Name=dev-edition-default
              IsRelative=1
              Path=Profiles/byem38pu.dev-edition-default

              [Profile1]
              Name=default
              IsRelative=1
              Path=Profiles/l20p8rp4.default
              Default=1

              [Profile0]
              Name=default-release
              IsRelative=1
              Path=Profiles/h2g96bw8.default-release

              [General]
              StartWithLastProfile=1
              Version=2

              [InstallC293F2A37E5B85C3]
              Default=Profiles/strise
              Locked=1
            '';
        "Library/Application Support/Firefox/installs.ini".text = # ini
          ''
            [69FE9373C2142565]
            Default=Profiles/default
            Locked=1

            [C293F2A37E5B85C3]
            Default=Profiles/strise
            Locked=1
          '';
      };
    })
    (lib.mkIf pkgs.stdenv.isLinux {
      home.packages = [ pkgs.firefox-devedition ];
    })
    {
      programs.firefox = {
        enable = true;
        profiles = {
          default = {
            inherit search settings userChrome;
            name = "Default";
            id = 0;
            isDefault = true;
            bookmarks = [ bangs ] ++ (import ./bookmarks/default.nix);
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
            bookmarks = [ bangs ] ++ (import ./bookmarks/strise.nix);
          };
        };
      };
    }
  ];
}
