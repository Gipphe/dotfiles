{ pkgs, util, ... }:
util.mkProgram {
  name = "kubectl";
  hm = {
    home.packages = [ pkgs.kubectl ];
    programs.fish = {
      shellAbbrs.k = "kubectl";
      functions.kube_get_secret = # fish
        ''
          k get secret $argv[1] -o yaml -n knowledge
        '';
    };
  };
}
