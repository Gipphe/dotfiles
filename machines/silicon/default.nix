{
  gipphe.host.silicon = {
    system = "aarch64-darwin";
    machine = "nix-darwin";
  };
  imports = [
    (
      { lib, util, ... }:
      util.mkToggledModule [ "machines" ] {
        name = "silicon";

        shared.gipphe = {
          username = "victor";
          homeDirectory = "/Users/victor";
          hostName = "silicon";
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
            windows-setup.enable = true;
          };
        };

        system-darwin = {
          nix.settings.auto-optimise-store = lib.mkForce false;
          system.defaults = {
            # ".GlobalPreferences"."com.apple.mouse.scaling" = 1;
            CustomUserPreferences = {
              "com.apple.dock"."workspaces-swoosh-animation-off" = true;
            };
          };
        };
      }
    )
  ];
}
