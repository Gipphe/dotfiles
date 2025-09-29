{ util, inputs, ... }:
util.mkToggledModule [ "lovdata" ] {
  name = "cli";
  hm = {
    imports = [ inputs.lovdata.homeModules.cli ];
    config.lovdata.cli.enable = true;
  };
}
