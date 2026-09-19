{ self, inputs, ... }:
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
        headset-battery-indicator = pkgs.callPackage ./headset-battery-indicator.nix {
          inherit (inputs)
            pyproject-nix
            headset-battery-indicator
            ;
        };
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
