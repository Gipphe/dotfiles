{ lib, config, ... }:
let
  extraConfig = ''
    DefaultTimeoutStopSec=16s
  '';
in
{
  config = lib.mkIf config.gipphe.system.systemd.enable {
    systemd = {
      inherit extraConfig;
      user = {
        inherit extraConfig;
      };
      services =
        {
          "getty@tty1".enable = false;
          "autovt@tty1".enable = false;
          "getty@tty7".enable = false;
          "autovt@tty7".enable = false;
          # slows down boot time
        }
        // lib.optionalAttrs config.gipphe.networking.networkmanager.enable {
          NetworkManager-wait-online.enable = false;
        };

      # Systemd OOMd
      # Fedora enables these options by deafult. See the 10-oomd-* files here:
      # https://src.fedoraproject.org/rpms/systemd/tree/acb90c49c42276b06375a66c73673ac3510255
      oomd.enableRootSlice = true;

      # TODO: channels-to-flakes
      tmpfiles.rules = [ "D /nix/var/nix/profiles/per-user/root 755 root root - -" ];
    };
  };
}
