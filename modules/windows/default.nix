{
  lib,
  pkgs,
  config,
  util,
  ...
}:
let
  inherit (builtins) throw;
  cfg = config.gipphe.windows;
  order = import ./order.nix;
  inherit (import ./psUtils.nix) toPowershell profileOpt;
  inherit (import ./util.nix { inherit lib; }) profileOpt;
in
util.mkModule {
  options.gipphe.windows = {
    enable = lib.mkEnableOption "Windows Powershell setup script";

    destination = lib.mkOption {
      description = ''
        Where to put the final Powershell script
      '';
      type = lib.types.str;
      default = throw "Missing options.windows.destination";
      example = "$HOME/projects/dotfiles/windows/Main.ps1";
    };

    profiles = profileOpt {};

    powershell-script = lib.mkOption {
      description = ''
        Final Powershell script.
      '';
      internal = true;
      type = lib.types.lines;
      default = "";
    };

    vcsPath = lib.mkOption {
      description = ''
        Path to VCS repo for this configuration. Used to find a spot for files
        that have to be committed into VCS to be carried over to Windows.
      '';
      type = lib.types.str;
      default = "${config.gipphe.homeDirectory}/projects/dotfiles";
    };
  };
  shared.imports = [
    ./chocolatey.nix
    ./env.nix
    ./games
    ./home.nix
    ./logger.nix
    ./programs.nix
    ./psUtils.nix
    ./registry.nix
    ./scoop.nix
    ./sd.nix
    ./stamp.nix
    ./wsl.nix
  ];
  hm = {
    imports = [
      (
        { lib, util, ... }:
        util.mkModule {
          hm.gipphe.windows.powershell-script =
            lib.mkOrder order.postamble # powershell
              ''
                } catch {
                  $Info = $error[0].InvocationInfo
                  Write-Host "Exception: $($Info.ScriptLineNumber): $($Info.Line)"
                  Write-Host $error
                  exit 1
                }
              '';
        }
      )
    ];
    gipphe.windows.powershell-script = (
      lib.mkOrder order.preamble
        # powershell
        ''
          #Requires -Version 5.1
          [CmdletBinding()]
          param ()

          $ErrorActionPreference = "Stop"
          $InformationPreference = "Continue"

          $Profiles = ${toPowershell (mapAttrs'
            (name: value: { name = toLower name; value = value // { profileName = name; }; })
            cfg.profiles
          )}

          $HostName = $Env:COMPUTERNAME.ToLower()

          if (-not ($Profiles.ContainsKey($HostName))) {
            Write-Error "Found no matching profile for hostname $HostName"
            exit 1
          }

          $Profile = $Profiles[$HostName]

          try {
        ''
    );
    home.activation.write-windows-script =
      let
        pkg = pkgs.writeText "windows-powershell-script" cfg.powershell-script;
      in
      lib.hm.dag.entryAfter [ "onFilesChange" ] ''
        run cp -f '${pkg}' '${cfg.destination}/Setup.ps1'
      '';
  };
}
