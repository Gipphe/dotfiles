{
  config,
  util,
  inputs,
  ...
}:
util.mkToggledModule [ "lovdata" ] {
  name = "mounts";
  system-nixos = {
    imports = [ inputs.lovdata.nixosModules.mounts ];
    config.lovdata.mounts = {
      enable = true;
      username = "${config.gipphe.username}";
      group = "${config.gipphe.username}";
      ssh.username = "vnb";
      configRoot = "/app";
      scripts.mount-lovdata.enable = true;
    };
  };
}
