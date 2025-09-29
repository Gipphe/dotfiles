{ util, inputs, ... }:
util.mkToggledModule [ "lovdata" ] {
  name = "dns";
  system-nixos = {
    imports = [ inputs.lovdata.nixosModules.dns ];
    lovdata.dns.enable = true;
  };
}
