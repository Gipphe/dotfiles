{ pkgs, specialArgs, modules, ... }:
let
  inherit (pkgs) lib;
  inherit (lib.modules) evalModules;

  evaluated = evalModules {
    inherit specialArgs;
    modules = modules;
  };
  cfg = evaluated.config;
in
{
  script = ./script.ps1;
  profiles = {
  home.file = cfg.home.file;
  chocolatey.programs = cfg.chocolatey.programs;
        };
}
