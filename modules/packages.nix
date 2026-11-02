{ self, inputs, ... }:
{
  perSystem = { pkgs, system, ... }: {
    packages =
      let
        util = inputs.flaketilities.lib.${system};
      in
      {
        md-fastfetch = pkgs.callPackage ./_packages/md-fastfetch.nix {
          inherit (util) writeNushellApplication;
        };
        md-icons = pkgs.callPackage ./_packages/md-icons.nix { inherit (util) writeNushellApplication; };
        headset-battery-indicator = pkgs.callPackage ./_packages/headset-battery-indicator.nix {
          inherit (inputs)
            pyproject-nix
            headset-battery-indicator
            ;
        };
        jagex-launcher = pkgs.callPackage ./_packages/jagex-launcher.nix { };
        openmouse-bridge = pkgs.callPackage ./_packages/openmouse-bridge.nix { };
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
