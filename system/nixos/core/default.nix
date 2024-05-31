{
  pkgs,
  lib,
  flags,
  ...
}:
{
  imports = [
    ./appimage.nix
    ./network.nix
    ./time-and-localization.nix
    ./utilities.nix
  ];

  systemd =
    let
      extraConfig = ''
        DefaultTimeoutStopSec=16s
      '';
    in
    lib.optionalAttrs flags.systemd {
      inherit extraConfig;
      user = {
        inherit extraConfig;
      };
      services = {
        "getty@tty1".enable = false;
        "autovt@tty1".enable = false;
        "getty@tty7".enable = false;
        "autovt@tty7".enable = false;
        # slows down boot time
      } // lib.optionalAttrs flags.networkmanager { NetworkManager-wait-online.enable = false; };

      # Systemd OOMd
      # Fedora enables these options by deafult. See the 10-oomd-* files here:
      # https://src.fedoraproject.org/rpms/systemd/tree/acb90c49c42276b06375a66c73673ac3510255
      oomd.enableRootSlice = true;

      # TODO: channels-to-flakes
      tmpfiles.rules = [ "D /nix/var/nix/profiles/per-user/root 755 root root - -" ];
    };

  services = {
    # Configure keymap in X11
    xserver.xkb = {
      layout = "no";
      variant = "";
    };

    # Enable CUPS to print documents.
    printing.enable = flags.printer;
  };

  console =
    let
      variant = "u24n";
    in
    {
      font = "${pkgs.terminus_font}/share/consolefonts/ter-${variant}.psf.gz";
      earlySetup = true;
      # Configure console keymap
      keyMap = "no";
    };

  services = {
    dbus = {
      packages = lib.optionals flags.desktop (
        with pkgs;
        [
          dconf
          udisks2
          gcr
        ]
      );
      enable = true;
    };
    # udev.packages = with pkgs; [
    #   gnome.gnome-settings-daemon
    #   android-udev-rules
    # ];
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
    # udisks2.enable = flags.desktop;
    # profile-sync-daemon
    # psd = {
    #   enable = true;
    #   resyncTimer = "10m";
    # };
  };

  # compress half of the ram to use as swap
  # zramSwap = {
  #   enable = lib.mkDefault false;
  #   algorithm = "zstd";
  # };

  # environment.systemPackages = with pkgs; [
  #   uutils-coreutils-noprefix
  #   # btrfs-progs
  #   # cifs-utils
  # ];

  hardware.ledger.enable = true;

  programs = {
    # allow users to mount fuse filesystems with allow_other
    # fuse.userAllowOther = true;

    # help manage android devices via command line
    # adb.enable = true;

    # Compatibility layer for dynamically linked binaries that expect FHS
    nix-ld.enable = true;

    # java = {
    #   enable = true;
    #   package = pkgs.temurin-jre-bin;
    # };
  };
}
