{ self, ... }: {
  perSystem = { self', pkgs, ... }: {
    devShells.default =
      let
        util = pkgs.callPackage ../../util.nix { };
      in
      pkgs.callPackage ./shell.nix {
        inherit (self'.packages) jujutsu;
        inherit (util) writeNushellApplication;
        sopsSecrets =
          self.nixosConfigurations.titanium.config.sops.secrets
          // self.nixosConfigurations.titanium.config.home-manager.users.gipphe.sops.secrets;
      };
  };
}
