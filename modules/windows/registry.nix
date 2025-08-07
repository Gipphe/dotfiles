{
  lib,
  config,
  util,
  ...
}:
let
  cfg = config.gipphe.windows.registry;
  regs = builtins.filter (x: x.enable) cfg.entries;
  stampifyPath =
    path: name:
    let
      pp =
        builtins.replaceStrings
          [
            "/"
            "\\"
          ]
          [
            "-"
            "-"
          ]
          path;
      pn =
        builtins.replaceStrings
          [
            "/"
            "\\"
          ]
          [
            "-"
            "-"
          ]
          name;
    in
    "${pp}-${pn}";
  order = import ./order.nix;
in
util.mkToggledModule [ "windows" ] {
  name = "registry";
  options.gipphe.windows.registry = {
    enableAutoLogin = lib.mkOption {
      description = ''
        Automatically log into an account. The account is configured when the script is ran.
      '';
      type = lib.types.bool;
      default = true;
    };
    entries = lib.mkOption {
      description = "Registry entries to add.";
      default = [ ];
      type =
        with lib.types;
        listOf (submodule {
          options = {
            enable = lib.mkOption {
              description = "Whether to enable management of the entry.";
              type = bool;
              default = true;
            };
            description = lib.mkOption {
              description = "Description for the registry entry and its effect.";
              type = lines;
            };
            path = lib.mkOption {
              description = "Registry path to write the entry to.";
              type = str;
            };
            entry = lib.mkOption {
              description = "Name of the entry to write.";
              type = str;
            };
            type = lib.mkOption {
              description = "Entry type.";
              type = str;
            };
            data = lib.mkOption {
              description = "Entry data.";
              type = anything;
            };
          };
        });
    };
  };
  hm = lib.mkIf (builtins.length regs > 0) {
    gipphe.windows.powershell-script =
      lib.mkOrder order.registry # powershell
        ''
          class Registry {
            [PSCustomObject]$Logger
            [PSCustomObject]$Stamp

            Registry([PSCustomObject]$Logger) {
              $this.Logger = $Logger
              $this.Stamp = New-Stamp
            }

            [Void] StampEntry([PSCustomObject]$ChildLogger, [String]$Stamp, [String]$Path, [String]$Entry, [String]$Type, [String]$Data) {
              $this.Stamp.Register($Stamp, {
                $ChildLogger.Info("Setting $Path\$Entry")
                reg add "$Path" /v "$Entry" /t "$Type" /d $Data /f
              })
            }

            [Void] SetEntries() {
              $this.Logger.Info(" Setting registry entries...")
              $ChildLogger = $this.Logger.ChildLogger()

              ${lib.pipe regs [
                (builtins.map (x: ''
                  # ${x.description}
                  $this.StampEntry(
                    $ChildLogger,
                    "${stampifyPath x.path x.entry}",
                    "${x.path}",
                    "${x.entry}",
                    "${x.type}",
                    "${if (!builtins.isString x.data) then builtins.toString x.data else x.data}"
                  )
                ''))
                (lib.concatStringsSep "\n")
              ]}

              ${lib.optionalString cfg.enableAutoLogin # powershell
                ''
                  $AutoLoginEnabled = $False
                  try {
                    $Prop = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon'
                    $Prop
                    $AutoLoginEnabled = $Prop.AutoAdminLogon -eq '1'
                    $AutoLoginEnabled
                  } catch { }

                  if (-not $AutoLoginEnabled) {
                    $Username = Read-Host "Enter username for auto-login"
                    $Password = Read-Host "Enter password for auto-login" -AsSecureString

                    # Convert SecureString password to plain text
                    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
                    $PlainPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

                    # Set registry keys
                    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'DefaultUserName' -Value $Username
                    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'DefaultPassword' -Value $PlainPass
                    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '1'

                    # Cleanup
                    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
                  }
                ''
              }

              $this.Logger.Info(" Registry entries set.")
            }
          }
        '';
  };
}
