{
  lib,
  config,
  util,
  ...
}:
let
  cfg = config.gipphe.windows.programs;
  progs = lib.filterAttrs (_: v: v.enable) cfg.manual;
  order = import ./order.nix;
in
util.mkToggledModule [ "windows" ] {
  name = "programs";
  options.gipphe.windows.programs = {
    manual = lib.mkOption {
      description = "Programs to install manually from an installer.";
      type =
        with lib.types;
        attrsOf (submodule {
          options = {
            enable = lib.mkOption {
              description = "Install this program.";
              type = bool;
              default = true;
            };
            stampName = lib.mkOption {
              description = ''
                Name of the stamp used to record the installation state of this
                program.
              '';
              type = str;
            };
            url = lib.mkOption {
              description = "URL for the installer.";
              type = str;
            };
          };
        });
      default = { };
      example = {
        "Firefox Developer Edition" = {
          stampName = "install-firefox-developer-edition";
          url = "https://download-installer.cdn.mozilla.net/pub/devedition/releases/120.0b4/win32/en-US/Firefox%20Installer.exe";
        };
      };
    };
  };
  hm = lib.mkIf (progs != { }) {
    gipphe.windows.powershell-script =
      lib.mkOrder order.programs # powershell
        ''
          class Programs {
            [PSCustomObject]$Logger
            [PSCustomObject]$Stamp

            Programs([PSCustomObject]$Logger, [PSCustomObject]$Stamp) {
              $this.Logger = $Logger
              $this.Stamp = $Stamp
            }

            [void] Install() {
              $this.Logger.Info(" Installing manually installed programs...")

              $ChildLogger = $this.Logger.ChildLogger()

              ${
                lib.pipe progs [
                  (lib.mapAttrsToList (
                    name: p: ''
                      $this.Stamp.Register("${p.stampName}", {
                        Install-FromWeb "${name}" "${p.url}" $ChildLogger
                      })
                    ''
                  ))
                  (lib.concatStringsSep "\n")
                ]
              }

              $this.Logger.Info(" Programs installed.")
            }
          }
          $Programs = [Programs]::new($Logger, $Stamp)
          $Programs.Install()
        '';
  };
}
