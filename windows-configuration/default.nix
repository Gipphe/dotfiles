{ pkgs, system, specialArgs, modules, ... }:
let
  inherit (pkgs) lib;
  inherit (lib.modules) evalModules;

  evaluated = evalModules {
    inherit specialArgs modules;
  };
in
specialArgs.util.mkModule {
  options.rootConfig = lib.mkOption {
    type = with lib.types; attrsOf anything;
  };
  shared.rootConfig = evaluated;
  shared.imports = [
    ./home.nix
  ];
}
