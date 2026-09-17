{
  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        nixfmt.enable = true;
        deadnix.enable = false;
        shellcheck.enable = true;
        shfmt.enable = true;
      };

      settings.formatter.nixfmt.excludes = [
        "modules/system/hardware-configuration/*.nix"
        "hardware-configuration.nix"
        "hosts/*/hardware-configuration.nix"
      ];
    };
  };
}
