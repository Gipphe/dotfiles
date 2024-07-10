{ util, ... }: util.mkProfile "k8s" { gipphe.programs.k9s.enable = true; }
