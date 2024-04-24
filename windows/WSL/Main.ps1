class WSL {
  [PSCustomObject]$Utils
  [PSCustomObject]$Stamp

  WSL() {
    $Dirname = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
    . "$Dirname\..\Utils.ps1"
    . "$Dirname\..\Stamp.ps1"

    $this.Utils = New-Utils
    $this.Stamp = New-Stamp
  }

  [void] Install() {
    $this.Stamp.Register("install-wsl", {
      $this.WSL.InvokeNative({ wsl --install })
    })

    $this.Stamp.Register("install-nixos-wsl", {
      Invoke-WebRequest `
        -Uri "https://github.com/nix-community/NixOS-WSL/releases/download/2311.5.3/nixos-wsl.tar.gz" `
        -OutFile "$Env:USERPROFILE\Downloads\nixos-wsl.tar.gz"
      $this.Utils.InvokeNative({ wsl --import "NixOS" "$Env:USERPROFILE\NixOS\" "$Env:USERPROFILE\Downloads\nixos-wsl.tar.gz" })
      $this.Utils.InvokeNative({ wsl --set-default "NixOS" })
    })

    $this.Stamp.Register("configure-nixos", {
      $this.Utils.InvokeNative({
        wsl -d "NixOS" -- `
          ! test -s '$HOME/projects/dotfiles' `
          '&&' nix-shell -p git --run '"git clone https://codeberg.org/Gipphe/dotfiles.git"' '"$HOME/projects/dotfiles"' `
          '&&' cd '$HOME/projects/dotfiles' `
          '&&' nixos-rebuild --extra-experimental-features 'flakes nix-command' switch --flake '"$(pwd)#Jarle"'
      })
    })
  }
}

Function New-WSL {
  [WSL]::new()
}
