{
  pkgs,
  util,
  lib,
  config,
  ...
}:
util.mkProgram {
  name = "kubectl";
  hm = {
    home.packages = lib.optional (!config.gipphe.programs.google-cloud-sdk.enable) [ pkgs.kubectl ];
    programs.fish = {
      shellAbbrs.k = "kubectl";
      functions.kube_get_secret = # fish
        ''
          k get secret $argv[1] -o yaml -n knowledge
        '';
    };
  };
}
