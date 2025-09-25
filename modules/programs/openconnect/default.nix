{
  util,
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.gipphe.programs.openconnect;
  inherit (inputs.openconnect-sso.packages.${pkgs.system}) openconnect-sso;
  openconnect = inputs.nixpkgs-openconnect-sso.legacyPackages.${pkgs.system}.openconnect;
  openconnect-lovdata = pkgs.writeShellScriptBin "openconnect-lovdata" ''
    ${lib.getExe' pkgs.systemd "systemctl"} start --user openconnect-lovdata.service
  '';
  reset-network =
    pkgs.writeShellScriptBin "reset-network" # bash
      ''
        ${pkgs.systemd}/bin/systemctl restart \
          network-setup.service \
          NetworkManager.service \
          nscd.service
      '';

  start-service =
    pkgs.writeShellScriptBin "start-service" # bash
      ''
        ${openconnect-sso}/bin/openconnect-sso \
          --server lovdataazure.ivpn.se \
          --browser-display-mode shown \
          -l DEBUG \
          -- \
          -b \
          -l \
          --pid-file=/run/ovpn.pid
      '';
in
util.mkProgram {
  name = "openconnect";
  options.gipphe.programs.openconnect = {
    lovdata.enable = lib.mkEnableOption "Lovdata config for OpenConnect";
  };
  hm = lib.mkMerge [
    {
      home.packages = [
        reset-network
        openconnect-sso
      ];
    }
    (lib.mkIf cfg.lovdata.enable {
      home.packages = [ openconnect-lovdata ];
      systemd.user.services.openconnect-lovdata = {
        Unit = {
          Description = "OpenConnect VPN";
          After = [ "network.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = lib.getExe start-service;
          Restart = "on-failure";
          PIDFile = "/run/ovpn.pid";
          ExecStop = ''${lib.getExe pkgs.bash} -c "sudo pkill openconnect"'';
        };
        Install.WantedBy = [ "multi-user.target" ];
      };
    })
  ];
  system-nixos = lib.mkIf cfg.lovdata.enable {
    security.sudo.extraRules = [
      {
        users = [ config.gipphe.username ];
        host = "ALL";
        runAs = "root";
        commands = [
          {
            # Necessary for openconnect-sso to run as a systemd service, since it uses sudo to invoke openconnect.
            options = [ "NOPASSWD" ];
            command = "${openconnect}/bin/openconnect";
          }
          {
            options = [ "NOPASSWD" ];
            command = "${pkgs.procps}/bin/pkill openconnect";
          }
        ];
      }
    ];
  };
}
