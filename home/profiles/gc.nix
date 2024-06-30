{ util, ... }: util.mkProfile "gc" { gipphe.programs.nix.gc.enable = true; }
