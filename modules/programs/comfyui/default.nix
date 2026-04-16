{ config, util, ... }:
let
  nixDaemonEnv = "/run/secrets/nix-daemon-env";
in
util.mkProgram {
  name = "comfyui";
  system-nixos = {
    sops.secrets.cai_api_key = {
      format = "binary";
      sopsFile = ../../../secrets/pub-cai-api-key.txt;
    };
    system.activationScripts.nix-daemon-env = {
      deps = [ "setupSecrets" ];
      text = ''
        printf 'CAI_API_KEY=%s\n' "$(cat ${config.sops.secrets.cai_api_key.path})" \
          > ${nixDaemonEnv}
        chmod 600 ${nixDaemonEnv}
      '';
    };

    systemd.services.nix-daemon.serviceConfig.EnvironmentFile = [ nixDaemonEnv ];
  };
}
