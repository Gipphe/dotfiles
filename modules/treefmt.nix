{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
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
        "modules/hosts/*/_hardware-configuration.nix"
      ];
    };
  };
}
