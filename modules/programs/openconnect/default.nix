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

        function is-running
          test -n "$(pgrep openconnect)"
        end

        function stop
          sudo pkill openconnect
          and echo "Stopped openconnect" >&2
        end

        function start
          sudo echo "Pre-authenticated sudo" >&2
          and openconnect-lovdata &>/dev/null &
          and echo "Started openconnect" >&2
        end

        switch $choice
          case start
            start
          case stop
            stop
          case status
            if is-running
              echo "Openconnect is running" >&2
            else
              echo "Openconnect is not running" >&2
            end
          case toggle
            if is-running
              stop
            else
              start
            end
          case '*'
            echo "Unknown mode: $choice, $argv"
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
    ];
  };
}
