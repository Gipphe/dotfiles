{ util, inputs, ... }:
util.mkToggledModule [ "lovdata" ] {
  name = "java_21";
  hm = {
    imports = [ inputs.lovdata.homeModules.java_21 ];
    config.lovdata.java_21.enable = true;
  };
}
