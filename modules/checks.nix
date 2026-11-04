{ self, ... }:
{
  perSystem =
    { system, lib, ... }:
    {

      checks =
        let
          filterSystem = lib.filterAttrs (_: c: c.pkgs.stdenv.hostPlatform.system == system);
          mkNixosCheck = name: x: {
            name = "nixos-${name}";
            value = x.config.system.build.toplevel;
          };
          # mkNixOnDroidCheck = name: x: {
          #   name = "nix-on-droid-${name}";
          #   value = x.activationPackage;
          # };
        in
        lib.pipe self.nixosConfigurations [
          filterSystem
          (lib.mapAttrs' mkNixosCheck)
        ]
      # // lib.pipe self.nixOnDroidConfigurations [
      #   filterSystem
      #   (lib.mapAttrs' mkNixOnDroidCheck)
      # ]
      ;
    };
}
