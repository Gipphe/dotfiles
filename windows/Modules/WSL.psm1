#Requires -Version 5.1

$ErrorActionPreference = "Stop"

Import-Module $PSScriptRoot/Utils.psm1
Import-Module $PSScriptRoot/Stamp.psm1

class WSL {
  [PSCustomObject]$Stamp

  WSL() {
    $this.Stamp = New-Stamp
  }

  [Void] Install() {
    $this.Stamp.Register("install-wsl", {
      Invoke-Native { wsl --install }
    })

    $this.Stamp.Register("install-nixos-wsl", {
      Invoke-WebRequest `
        -Uri "https://github.com/nix-community/NixOS-WSL/releases/download/2311.5.3/nixos-wsl.tar.gz" `
        -OutFile "$HOME\Downloads\nixos-wsl.tar.gz"
      Invoke-Native { wsl --import "NixOS" "$HOME\NixOS\" "$HOME\Downloads\nixos-wsl.tar.gz" }
      Invoke-Native { wsl --set-default "NixOS" }
    })

    $this.Stamp.Register("configure-nixos", {
      Invoke-Native {
        wsl -d "NixOS" -- `
          ! test -s '$HOME/projects/dotfiles' `
          '&&' nix-shell -p git --run '"git clone https://codeberg.org/Gipphe/dotfiles.git"' '"$HOME/projects/dotfiles"' `
          '&&' cd '$HOME/projects/dotfiles' `
          '&&' nixos-rebuild --extra-experimental-features 'flakes nix-command' switch --flake '"$(pwd)#Jarle"'
      }
    })
  }
}

function New-WSL {
  [WSL]::new()
}

Export-ModuleMember -Function New-WSL
