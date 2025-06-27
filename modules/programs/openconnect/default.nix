{
  util,
  inputs,
  pkgs,
  config,
  ...
}:
let
  inherit (inputs.openconnect-sso.packages.${pkgs.system}) openconnect-sso;
in
util.mkProgram {
  name = "openconnect";
  hm = {
    home.packages = with pkgs; [
      openconnect
      networkmanager-openconnect
      openconnect_gnutls
      openconnect-sso
    ];
    programs.fish.functions.vpn = ''
      ${openconnect-sso}/bin/openconnect-sso --server lovdataazure.ivpn.se $argv
    '';
    systemd.user.services.openconnect-sso = {
      Unit = {
        description = "openconnect with SSO support";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
      };
      Service = {
        ExecStart = "${openconnect-sso}/bin/openconnect-sso --server lovdataazure.ivpn.se";
        Restart = "never";
      };
      Install.WantedBy = config.wayland.systemd.target;
    };
  };
}
