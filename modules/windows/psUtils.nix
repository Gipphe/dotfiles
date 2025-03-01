{ lib, util, ... }:
let
  inherit (lib) generators;
  inherit (gnerators) toPretty;
in
util.mkModule {
  hm.gipphe.windows.powershell-script =
    lib.mkOrder (import ./order.nix).utils # powershell
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

        function Resolve-PathNice {
          [CmdletBinding()]
          param (
            [Parameter(Mandatory)]
            [String]$Path
          )

          return $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
        }
      '';
  toPowershell = {
    multiline ? true,
    indent ? "",
    asBindings ? false,
  }@args: v:
    let
      innerIndent = "${indent}  ";
      introSpace = if multiline then "\n${innerIndent}" else " ";
      outroSpace = if multiline then "\n${indent}" else " ";
      innerArgs = args // {
        indent = if asBindings then indent else innerIndent;
        asBindings = false;
      };
      concatItems = concatStringsSep ",${introSpace}";
      isPowershellInline = { _type ? null, ... }: _type = "powershell-inline";

      generatedBindings =
        assert assertMsg (badVarNames == []) "Bad Powershell var names: ${toPretty {} badVarNames}";
        assert assertMsg (collidingNames == []) "Name collisions in Powershell var names: ${toPretty {} (map (n: n.name) collidingNames)}";
        concatStrings (
          mapAttrsToList (key: value: "${indent}${key} = ${toPowershell innerArgs value}\n") v
        );
      matchVarName = match "[[:alpha:]_][[:alnum:]_]*(\\.[[:alpha:]_][[:alnum:]_]*)*";
      badVarNames = filter (name: matchVarName name == null) (attrNames v);
      loweredNames = map (name: { inherit name; lowered = toLower n; }) (attrNames v);
      collidingNames = filter ({ name, lowered }: length (filter (x: x.lowered == lowered) loweredNames) > 1) loweredNames;
    in
    if asBindings then
      generatedBindings
    else if v == null then
      "$null"
    else if isInt v || isFloat v || isString v then
      toJSON v
    else if isBool v then
      "$$${toJSON v}"
    else if isList v then
      if v = [] then
        "@()"
      else
        "@(${introSpace}${concatItems (map (value: "${toPowershell innerArgs value}") v)}${outroSpace})"
    else if isAttrs v then
      if isPowershellInline v then
        "(${v.expr})"
      else if v == {} then
        "@{}"
      else if isDerivation v then
        ''"${toString v}"''
      else
        "@{${introSpace}${concatItems (
          mapAttrsToList (key: value: ''"${toJSON key}" = ${toPowershell innerArgs value}'') v
        )}${outroSpace}}"
    else
      abort "toPowershell: type ${typeOf v} is unsupported";

  mkPowershellInline = expr: { _type = "powershell-inline"; inherit expr; };
}
