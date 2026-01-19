{ util, pkgs, ... }:
util.mkToggledModule [ "system" "thumbnails" ] {
  name = "document";
  system-nixos = {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        poppler # PDF
        # TODO: Broken dependency openturns.
        # See:
        # - https://github.com/NixOS/nixpkgs/pull/480871
        # - https://github.com/NixOS/nixpkgs/issues/480860
        # - https://github.com/NixOS/nixpkgs/issues/481019
        # f3d # 3D files
        ;
    };
  };
}
