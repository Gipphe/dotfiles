{
  config,
  util,
  inputs,
  pkgs,
  ...
}:
let
  steam = config.programs.steam.package;
in
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
      applications = {
        env = {
          PATH = "$(PATH):$(HOME)/.local/bin";
        };
        apps = [
          {
            name = "Desktop";
            image-path = "desktop.png";
          }
          {
            name = "Steam Big Picture";
            detached = [
              "${pkgs.util-linux.bin}/bin/setsid ${steam}/bin/steam steam://open/bigpicture"
            ];
            prep-cmd = [
              {
                do = "";
                undo = "${pkgs.util-linux.bin}/bin/setsid ${steam}/bin/steam steam://close/bigpicture";
              }
            ];
            image-path = "steam.png";
          }
        ];
      };
    };
  };
}
