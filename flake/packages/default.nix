{ self, ... }:
{
  perSystem = { pkgs, ... }: {
    packages =
      let
        util = pkgs.callPackage ./util.nix { };
      in
      {
        md-fastfetch = pkgs.callPackage ./packages/md-fastfetch.nix {
          inherit (util) writeNushellApplication;
        };
        md-icons = pkgs.callPackage ./packages/md-icons.nix { inherit (util) writeNushellApplication; };
        mo2installer = pkgs.callPackage ./packages/mo2installer.nix { };
        fluorine-manager = pkgs.callPackage ./packages/fluorine-manager.nix { };
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
