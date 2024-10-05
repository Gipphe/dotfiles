{ lib, util, ... }:
util.mkModule {
  hm.gipphe.windows.powershell-script =
    lib.mkOrder 20 # powershell
      ''
        function Install-FromWeb {
          [CmdletBinding()]
          param (
            [Parameter(Mandatory)]
            [String]$Name,

            [Parameter(Mandatory)]
            [String]$URI,

            [Parameter(Mandatory)]
            [PSCustomObject]$Logger
          )

          if (Test-IsInstalledInWinget $Name)
          {
            $this.Logger.Info("$Name is already installed")
            return
          }

          $this.Logger.Info(@(Invoke-WebRequest -URI $URI -OutFile "$HOME/Downloads/temp.exe"))

          Start-Process "$HOME/Downloads/temp.exe" -Wait
          Remove-Item "$HOME/Downloads/temp.exe"
          $this.Logger.Info("Installed $Name")
        }

        $script:WingetPrograms = $null

        function Test-IsInstalledInWinget {
          [CmdletBinding()]
          param (
            [Parameter(Mandatory)]
            [String]$Name
          )

          if ($null -eq $script:WingetPrograms) {
            $script:WingetPrograms = $($(winget list).ToLower() -split "`n")
          }

          $Name = $Name.ToLower()

          foreach ($line in $script:WingetPrograms) {
            if ($line.StartsWith($Name)) {
              return $true
            }
          }
          return $false
        }

        function New-Shortcut {
          [CmdletBinding()]
          param (
            [Parameter(Mandatory)]
            [ValidateScript({ Test-Path $_ })]
            [String]$Source,

            [Parameter(Mandatory)]
            [String]$Destination,

            [Parameter(Mandatory)]
            [String]$Arguments,

            [Parameter(Mandatory)]
            [PSCustomObject]$Logger
          )

          $WshShell = New-Object -comObject WScript.Shell
          $Shortcut = $WshShell.CreateShortcut($Destination)
          $Shortcut.TargetPath = $Source
          $Shortcut.Arguments = $Arguments
          $Shortcut.Save()
          $this.Logger.Info("Created shortcut")
        }

        function Install-WithWinget {
          [CmdletBinding()]
          param (
            [Parameter(Mandatory)]
            [String]$Name
          )

          If (-Not (Test-IsInstalledInWinget $Name))
          {
            Invoke-Native { winget install --name $Name }
          }
        }

        function Invoke-Native {
          [CmdletBinding()]
          param (
            [Parameter(Mandatory)]
            [ScriptBlock]$ScriptBlock
          )

          & @ScriptBlock
          If ($LASTEXITCODE -Ne 0)
          {
            Write-Error "Non-zero exit code $LASTEXITCODE"
            Exit $LASTEXITCODE 
          }
        }
      '';
}
