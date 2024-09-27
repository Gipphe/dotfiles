#Requires -Version 5.1

$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

Import-Module $PSScriptRoot/Utils.psm1
Import-Module $PSScriptRoot/Stamp.psm1

class WSL {
  [PSCustomObject]$Logger
  [PSCustomObject]$Stamp

  WSL([PSCustomObject]$Logger) {
    $this.Logger = $Logger
    $this.Stamp = New-Stamp
  }

  [Void] Install() {
    $this.Logger.Info(" Installing and setting up WSL...")
    $ChildLogger = $this.Logger.ChildLogger()
    $this.Stamp.Register("install-wsl", {
      $ChildLogger.Info($(Invoke-Native { wsl --install }))
    })

    $this.Stamp.Register("install-nixos-wsl", {
      $ChildLogger.Info($(Invoke-WebRequest `
        -Uri "https://github.com/nix-community/NixOS-WSL/releases/download/2311.5.3/nixos-wsl.tar.gz" `
        -OutFile "$HOME\Downloads\nixos-wsl.tar.gz"
      ))
      $ChildLogger.Info($(Invoke-Native { wsl --import "NixOS" "$HOME\NixOS\" "$HOME\Downloads\nixos-wsl.tar.gz" }))
      $ChildLogger.Info($(Invoke-Native { wsl --set-default "NixOS" }))
    })

    $this.Stamp.Register("configure-nixos", {
      $ChildLogger.Info($(Invoke-Native {
        wsl -d "NixOS" -- `
          ! test -s '$HOME/projects/dotfiles' `
          '&&' nix-shell -p git --run '"git clone https://codeberg.org/Gipphe/dotfiles.git"' '"$HOME/projects/dotfiles"' `
          '&&' cd '$HOME/projects/dotfiles' `
          '&&' nixos-rebuild --extra-experimental-features 'flakes nix-command' switch --flake '"$(pwd)#Jarle"'
        ))
      }
    })
    $this.Logger.Info(" WSL installed and set up.")
  }
}

function New-WSL {
  param (
    [Parameter(Mandatory)]
    [PSCustomObject]$Logger
  )
  [WSL]::new($Logger)
}

Export-ModuleMember -Function New-WSL
