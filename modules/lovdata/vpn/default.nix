{ util, inputs, ... }:
util.mkToggledModule [ "lovdata" ] {
  name = "vpn";
  system-nixos = {
    imports = [ inputs.lovdata.nixosModules.vpn ];
    config.lovdata.vpn.enable = true;
  };
}
