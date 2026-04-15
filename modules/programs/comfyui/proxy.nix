{
  lib,
  pkgs,
  config,
  util,
  ...
}:
let
  mitm_port = "14031";
  mitm_script = pkgs.writeText "comfyui-mitmproxy" /* python */ ''
    with open("${config.sops.secrets.cai-api-key.path}") as f:
        TOKEN = f.read().strip()

    def request(flow):
        if TOKEN and "civitai.com" in flow.request.pretty_host:
            flow.request.headers["Authorization"] = f"Bearer {TOKEN}"
  '';
  userGroup = "cai-proxy";
  bundlePath = "/run/nix-daemon-ca/ca-bundle.crt";
  proxyAddress = "http://127.0.0.1:${toString mitm_port}";
in
util.mkModule {
  system-nixos.config = lib.mkIf config.gipphe.programs.comfyui.enable {
    sops.useSystemdActivation = true;
    sops.secrets = {
      cai-api-key = {
        format = "binary";
        sopsFile = ../../../secrets/pub-cai-api-key.txt;
        owner = userGroup;
      };
      cai-mitmproxy-ca-cert = {
        mode = "0444";
        format = "binary";
        sopsFile = ../../../secrets/pub-cai-mitm-ca.crt;
      };
      cai-mitmproxy-ca = {
        format = "binary";
        sopsFile = ../../../secrets/pub-cai-mitm-ca.pem;
      };
    };
    environment.variables = {
      CURL_CA_BUNDLE = bundlePath;
      NIX_SSL_CERT_FILE = bundlePath;
    };
    networking.proxy = {
      httpProxy = proxyAddress;
      httpsProxy = proxyAddress;
    };
    systemd.services = {
      cai-proxy = {
        description = "mitmproxy proxy injecting auth";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          # mitmproxy expects mitmproxy-ca.pem (cert + key) in confdir;
          # copy it from the sops secret before starting
          ExecStartPre = "+${pkgs.writeShellScript "setup-mitm-confdir" ''
            install -d -m 750 -o ${userGroup} -g ${userGroup} /var/lib/cai-proxy/conf
            install -m 600 -o ${userGroup} -g ${userGroup} \
              ${config.sops.secrets.cai-mitmproxy-ca.path} \
              /var/lib/cai-proxy/conf/mitmproxy-ca.pem
          ''}";
          ExecStart = lib.escapeShellArgs [
            "${pkgs.mitmproxy}/bin/mitmdump"
            "--listen-host"
            "127.0.0.1"
            "--listen-port"
            (toString mitm_port)
            "--set"
            "confdir=/var/lib/cai-proxy/conf"
            "-s"
            "${mitm_script}"
          ];
          StateDirectory = "cai-proxy";
          User = userGroup;
          Group = userGroup;
          Restart = "on-failure";
          RestartSec = "3s";
        };
      };
      nix-daemon = {
        after = [ config.systemd.services.nix-daemon-ca-bundle.name ];
      };
      nix-daemon-ca-bundle = {
        description = "Build CA bundle for nix-daemon including mitmproxy cert";
        wantedBy = [ "multi-user.target" ];
        before = [ config.systemd.services.nix-daemon.name ];
        after = [ config.systemd.services.sops-install-secrets.name ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          RuntimeDirectory = "nix-daemon-ca";
          ExecStart = pkgs.writeShellScript "build-ca-bundle" ''
            mkdir -p /run/nix-daemon-ca
            cat ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt \
                ${config.sops.secrets.cai-mitmproxy-ca-cert.path} \
                > ${bundlePath}
          '';
        };
      };
    };
    users = {
      users.cai-proxy = {
        isSystemUser = true;
        group = "cai-proxy";
      };
      groups.cai-proxy = { };
    };
  };
}
