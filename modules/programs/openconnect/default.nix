{
  util,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (inputs.openconnect-sso.packages.${pkgs.system}) openconnect-sso;
  openconnect-lovdata = pkgs.writeShellScriptBin "openconnect-lovdata" ''
    ${openconnect-sso}/bin/openconnect-sso --server lovdataazure.ivpn.se "$@"
  '';
  vpn = util.writeFishApplication {
    name = "vpn";
    runtimeInputs = [
      openconnect-lovdata
      pkgs.gum
      pkgs.procps
    ];
    text = # fish
      ''
        set -l modes start stop status toggle
        set -l choice $argv[1]
        not contains "$choice" $modes
        and set choice (gum choose $modes)

        function info
          echo $argv >&2
        end

        function is-running
          test -n "$(pgrep openconnect)"
        end

        function stop
          sudo pkill openconnect
          and info "Stopped openconnect"
          or begin
            info "Could not stop openconnect"
            info "Openconnect might not have been running"
          end
        end

        function start
          sudo echo "Pre-authenticated with sudo" >&2
          and openconnect-lovdata &>/dev/null &
          info "Started openconnect"
        end

        switch $choice
          case start
            start
          case stop
            stop
          case status
            if is-running
              info "Openconnect is running"
            else
              info "Openconnect is not running"
            end
          case toggle
            if is-running
              stop
            else
              start
            end
          case '*'
            info "Unknown mode: $choice, $argv"
        end
      '';
  };
  reset-network = util.writeFishApplication {
    name = "reset-network";
    runtimeInputs = [ pkgs.systemd ];
    text = # fish
      ''
        for s in network-setup NetworkManager nscd
          systemctl restart network-setup.service
          systemctl restart NetworkManager.service
          systemctl restart nscd.service
        end
      '';
  };
in
util.mkProgram {
  name = "openconnect";
  options.gipphe.programs.openconnect = {
    openconnect-lovdata = lib.mkOption {
      default = openconnect-lovdata;
      description = "Script to connect to Lovdata's VPN";
    };
  };
  hm = {
    home.packages = with pkgs; [
      openconnect
      networkmanager-openconnect
      openconnect_gnutls
      openconnect-sso
      openconnect-lovdata
      vpn
      reset-network
    ];
  };
}
