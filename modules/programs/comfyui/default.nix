{
  # inputs,
  config,
  util,
  ...
}:
let
  nixDaemonEnv = "/run/secrets/nix-daemon-env";
  mod = util.mkProgram {
    name = "comfyui";
    system-nixos = {
      # imports = [
      #   inputs.comfyui.nixosModules.default
      # ];
      # services.comfyui = {
      #   enable = true;
      #   dataDir = "/mnt/sub/projects/stable-diffusion/AltXL2/ComfyUI/";
      #   openFirewall = true;
      #   listenAddress = "0.0.0.0";
      #   port = 8189;
      #   enableManager = true;
      #   gpuSupport = "cuda";
      # };
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
  };
in
util.mkModule {
  shared.imports = [ mod ];
  system-nixos = {
    nix.settings = {
      extra-substituters = [
        "https://comfyui.cachix.org"
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org" # Legacy, still works
      ];
      extra-trusted-public-keys = [
        "comfyui.cachix.org-1:33mf9VzoIjzVbp0zwj+fT51HG0y31ZTK3nzYZAX0rec="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };
  };
}
