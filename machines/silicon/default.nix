{ lib, util, ... }:
let
  host = import ./host.nix;
  username = "victor";
in
util.mkToggledModule [ "machines" ] {
  inherit (host) name;

  shared.gipphe = {
    inherit username;
    homeDirectory = "/Users/victor";
    hostName = host.name;
    profiles = {
      ai.enable = true;
      application.enable = true;
      cli.enable = true;
      containers.enable = true;
      core.enable = true;
      darwin.enable = true;
      game-dev.enable = true;
      home-vpn.enable = true;
      k8s.enable = true;
      kvm.enable = true;
      logitech.enable = true;
      music.enable = true;
      rice.enable = true;
      secrets.enable = true;
      strise.enable = true;
      terminal-capture.enable = true;
      windows-setup.enable = true;
    };
  };

  system-darwin = {
    nix.settings.auto-optimise-store = lib.mkForce false;
    system = {
      primaryUser = username;
      defaults = {
        # ".GlobalPreferences"."com.apple.mouse.scaling" = 1;
        CustomUserPreferences = {
          "com.apple.dock"."workspaces-swoosh-animation-off" = true;
        };
      };
    };
  };
}
