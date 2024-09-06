{ util, ... }: util.mkProfile "systemd" { gipphe.programs.run-as-service.enable = true; }
