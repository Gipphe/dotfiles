{ self, ... }:
{
  perSystem = { pkgs, ... }: {
    packages =
      let
        util = pkgs.callPackage ../../util.nix { };
      in
      {
        md-fastfetch = pkgs.callPackage ./md-fastfetch.nix {
          inherit (util) writeNushellApplication;
        };
        md-icons = pkgs.callPackage ./md-icons.nix { inherit (util) writeNushellApplication; };
        mo2installer = pkgs.callPackage ./mo2installer.nix { };
        fluorine-manager = pkgs.callPackage ./fluorine-manager.nix { };
      }
      // (
        let
          x = self.nixosConfigurations.titanium.config.home-manager.users.gipphe.gipphe.programs;
        in
        {
          jujutsu = x.jujutsu.package;
          git = x.git.package;
        }
      );
  };
}
