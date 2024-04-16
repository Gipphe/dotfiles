[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

. "$Dirname\utils.ps1"
. "$Dirname\stamp.ps1"

Function Install-Wsl
{
  [CmdletBinding()]
  Param ()

  Register-Stamp "install-wsl" {
    Invoke-Native { wsl --install }
  }

  Register-Stamp "install-nixos-wsl" {
    Invoke-WebRequest `
      -Uri "https://github.com/nix-community/NixOS-WSL/releases/download/2311.5.3/nixos-wsl.tar.gz" `
      -OutFile "$Env:USERPROFILE\Downloads\nixos-wsl.tar.gz"
    Invoke-Native { wsl --import "NixOS" "$Env:USERPROFILE\NixOS\" "$Env:USERPROFILE\Downloads\nixos-wsl.tar.gz" }
    Invoke-Native { wsl --set-default "NixOS" }
  }

  Register-Stamp "configure-nixos" {
    Invoke-Native {
        wsl -d "NixOS" -- `
          ! test -s '$HOME/projects/dotfiles' `
          '&&' nix-shell -p git --run '"git clone https://codeberg.org/Gipphe/dotfiles.git"' '"$HOME/projects/dotfiles"' `
          '&&' cd '$HOME/projects/dotfiles' `
          '&&' nixos-rebuild --extra-experimental-features 'flakes nix-command' switch --flake '"$(pwd)#Jarle"'
    }
  }
}
