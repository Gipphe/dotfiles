{ util, inputs, ... }:
util.mkToggledModule [ "lovdata" ] {
  name = "memcached";
  hm = {
    imports = [ inputs.lovdata.homeModules.memcached ];
    config.lovdata.memcached.enable = true;
  };
}
