{ pkgs, ... }:
let
  inherit (pkgs) lib;
in
{
  mkWindowsConfiguration =
    {
      specialArgs ? { },
      modules ? [ ],
      ...
    }:
    let
      evaluated = lib.modules.evalModules {
        specialArgs = {
          inherit pkgs lib;
        } // specialArgs;
        modules = modules ++ [ ./module.nix ];
      };
    in
    {
      configuration = evaluated.config;
    };
}
