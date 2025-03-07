{ pkgs, system, specialArgs, modules, ... }:
let
  inherit (pkgs) lib;
  inherit (lib.modules) evalModules;

  evaluated = evalModules {
    inherit specialArgs;
    modules = modules ++ [
      {
        options.windows.profile = lib.mkOption {
          description = "Full Windows confiuration";
          type = with lib.types; attrsOf anything;
        };
      }
    ];
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
