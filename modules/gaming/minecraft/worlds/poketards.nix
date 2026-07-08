{
  pkgs,
  util,
  inputs,
  ...
}:
let
  javaPort = 25565;
  bedrockPort = 19132;
in
util.mkToggledModule [ "gaming" "minecraft" "servers" "worlds" ] {
  name = "poketards";
  nixos = {
    networking.firewall = {
      allowedTCPPorts = [ javaPort ];
      allowedUDPPorts = [ bedrockPort ];
    };
    services.minecraft-servers = {
      servers.poketards = {
        enable = true;
        autoStart = false;
        package =
          inputs.nix-minecraft.legacyPackages.${pkgs.stdenv.hostPlatform.system}.paperServers.paper-26_1_2;
        jvmOpts = "-Xms4G -Xmx4G -XX:+UseG1GC";
        serverProperties = {
          server-port = javaPort;
          gamemode = "adventure";
          difficulty = "peaceful";
          white-list = false;
          online-mode = true;
          level-seed = "i.backed.this.one.up";
        };
        operators = {
          Gipphe = {
            level = 4;
            uuid = "18f3cbac-ada8-4dd2-88df-37c72eb8140b";
          };
        };
        symlinks = {
          # Allows bedrock players to join Java server
          "plugins/Geyser-Spigot.jar" = pkgs.fetchurl {
            pname = "Geyser-Spigot.jar";
            version = "2026-29-6-1177";
            url = "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot";
            hash = "sha256-UqBOIsSHajV7V6kFiMXl4plrfWfF2Rn6yQkaCSNSq8I=";
          };
          # Authenticates Bedrock players as Java players using their Bedrock
          # account (otherwise they'd need a paid Java account)
          "plugins/Floodgate-Spigot.jar" = pkgs.fetchurl {
            pname = "Floodgate-Spigot.jar";
            version = "2026-29-6-138";
            url = "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot";
            hash = "sha256-RL25COL7T/G5dNUxPQSKYlohVVqYRM+4Ylapjo4ca9E=";
          };
          # Fixes some inconsistencies between Bedrock and Java in ways that
          # Geyser developers don't want to include in the base Geyser mod
          # because of potential exploitation.
          # At this time of writing, all it does is disable server-side
          # collision for bamboo and dripstone, since those have offset
          # collisions between Bedrock and Java.
          "plugins/hurricane-spigot.jar" = pkgs.fetchurl {
            pname = "hurricane-spigot.jar";
            version = "2026-05-30-4";
            url = "https://download.geysermc.org/v2/projects/hurricane/versions/latest/builds/latest/downloads/spigot";
            hash = "sha256-VhWJaY+znUxtRpiRmD7bb/u6Q+zJgkSJUNyaVRdqav4=";
          };
        };
        files = {
          "plugins/Geyser-Spigot/config.yml" = pkgs.writeText "config.yml" ''
            bedrock:
              address: 0.0.0.0
              port: ${toString bedrockPort}
            remote:
              address: auto
              port: ${toString javaPort}
              auth-type: floodgate
            floodgate-key-file: ../floodgate/key.pem
          '';
        };
      };
    };
  };
}
