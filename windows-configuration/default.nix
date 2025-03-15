{ pkgs, system, specialArgs, modules, ... }:
let
  inherit (pkgs) lib;
  inherit (lib.modules) evalModules;

  evaluated = evalModules {
    inherit specialArgs;
    modules = modules;
  };
in
specialArgs.util.mkModule {
  options.rootConfig = lib.mkOption {
    type = with lib.types; attrsOf anything;
  };
  shared.rootConfig = evaluated;
  home.activation.write-windows-script =
    let
      pkg = pkgs.writeText "windows-powershell-script" cfg.powershell-script;
    in
    lib.hm.dag.entryAfter [ "onFilesChange" ] ''
      run cp -f '${pkg}' '${cfg.destination}/Setup.ps1'
    '';
}
