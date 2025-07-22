{
  util,
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (inputs.openconnect-sso.packages.${pkgs.system}) openconnect-sso;
  cfg = config.gipphe.programs.openconnect;
  openconnect-lovdata = pkgs.writeShellScriptBin "openconnect-lovdata" ''
    ${openconnect-sso}/bin/openconnect-sso --server lovdataazure.ivpn.se "$@"
  '';
in
util.mkProgram {
  name = "openconnect";
  options.gipphe.programs.openconnect = {
    openconnect-lovdata = lib.mkOption {
      default = openconnect-lovdata;
      description = "Script to connect to Lovdata's VPN";
    };
    systemd = lib.mkEnableOption "systemd auto-start" // {
      default = true;
    };
  };
  hm = {
    home.packages = with pkgs; [
      openconnect
      networkmanager-openconnect
      openconnect_gnutls
      openconnect-sso
      openconnect-lovdata
    ];
    programs.fish.shellAbbrs.vpn = "systemctl --user start openconnect-sso.service";
    systemd.user.services.openconnect-sso =
      {
        Unit = {
          Description = "openconnect with SSO support";
          After = [ config.wayland.systemd.target ];
          PartOf = [ config.wayland.systemd.target ];
        };
        Service = {
          ExecStart = "${openconnect-lovdata}/bin/openconnect-lovdata";
          Restart = "never";
        };
      }
      // lib.optionalAttrs cfg.systemd {
        Install.WantedBy = [ config.wayland.systemd.target ];
      };
  };
}
