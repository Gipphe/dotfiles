{ util, lib, ... }:
util.mkToggledModule [ "windows" ] {
  name = "wsl";
  hm.gipphe.windows.powershell-script =
    lib.mkOrder (import ./order.nix).wsl # powershell
      ''
        class WSL {
          [PSCustomObject]$Logger
          [PSCustomObject]$Stamp

          WSL([PSCustomObject]$Logger, [PSCustomObject]$Stamp) {
            $this.Logger = $Logger
            $this.Stamp = $Stamp
          }

          [Void] Install() {
            $this.Logger.Info(" Installing and setting up WSL...")
            $ChildLogger = $this.Logger.ChildLogger()

            $ChildLogger.Info(" Install WSL")
            $this.Stamp.Register("install-wsl", {
              $ChildLogger.Info($(Invoke-Native { wsl --install }))
            })
            $ChildLogger.Info(" WSL installed")

            $ChildLogger.Info(" Install nixos-wsl image")
            $this.Stamp.Register("install-nixos-wsl", {
              $ChildLogger.Info($(Invoke-WebRequest `
                -Uri "https://github.com/nix-community/NixOS-WSL/releases/download/2411.6.0/nixos.wsl" `
                -OutFile "$HOME\Downloads\nixos.wsl" `
              ))
              $ChildLogger.Info($(Invoke-Native { wsl --install --name "NixOS" --location "$HOME/WSL/NixOS" --from-file "$HOME\Downloads\nixos.wsl" }))
              $ChildLogger.Info($(Invoke-Native { wsl --set-default "NixOS" }))
            })
            $ChildLogger.Info(" nixos-wsl installed")

            $ChildLogger.Info(" Configure nixos-wsl")
            $this.Stamp.Register("configure-nixos", {
              $ChildLogger.Info($(Invoke-Native {
                wsl -d "NixOS" -- `
                  ! test -s '$HOME/projects/dotfiles' `
                  '&&' nix-shell -p git --run '"git clone https://codeberg.org/Gipphe/dotfiles.git"' '"$HOME/projects/dotfiles"' `
                  '&&' cd '$HOME/projects/dotfiles' `
                  '&&' nixos-rebuild --extra-experimental-features 'flakes nix-command' switch --flake '"$(pwd)#argon"'
              }))
            })
            $ChildLogger.Info(" nixos-wsl configured")
            $this.Logger.Info(" WSL installed and set up.")
          }
        }
        $WSL = [WSL]::new($Logger, $Stamp)
        $WSL.Install()
      '';
}
