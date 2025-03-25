{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    { flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (_: {
      homeManagerModules = {
        default = import ./default.nix;
      };
    });
}
