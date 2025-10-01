{
  util,
  pkgs,
  config,
  inputs,
  ...
}:
util.mkToggledModule [ "lovdata" ] {
  name = "cli";
  hm = {
    imports = [ inputs.lovdata.homeModules.cli ];
    config = {
      home.packages = [
        (pkgs.writeShellScriptBin "lov" ''
          ${config.lovdata.cli.finalPackage}/bin/lovdata "$@"
        '')
      ];
      lovdata.cli.enable = true;
    };
  };
}
