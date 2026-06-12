{
  util,
  inputs,
  pkgs,
  ...
}:
util.mkProgram {
  name = "sunshine";
  nixos = {
    services.sunshine = {
      enable = true;
      # TODO: Remove once https://github.com/NixOS/nixpkgs/pull/521906 is in
      # nixos-unstable.
      package = inputs.nixpkgs-sunshine.legacyPackages.${pkgs.stdenv.hostPlatform.system}.sunshine;
      autoStart = false;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
