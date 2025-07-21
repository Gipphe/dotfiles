{
  util,
  inputs,
  ...
}:
util.mkProgram {
  name = "solaar";
  system-nixos = {
    imports = [ inputs.solaar.nixosModules.default ];
    services.solaar = {
      enable = true;
      window = "hide";
    };
  };
}
