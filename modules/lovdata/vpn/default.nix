{
  util,
  inputs,
  config,
  ...
}:
util.mkToggledModule [ "lovdata" ] {
  name = "vpn";
  system-nixos = {
    imports = [ inputs.lovdata.nixosModules.vpn ];
    config.lovdata.vpn = {
      enable = true;
      systemd.service = {
        username = config.gipphe.username;
      };
      scripts = {
        start-vpn.enable = true;
        reset-network.enable = true;
      };
    };
  };
}
