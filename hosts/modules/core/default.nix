{ pkgs, lib, ... }:
{
  imports = [ ./network.nix ];
  systemd =
    let
      extraConfig = ''
        DefaultTimeoutStopSec=16s
      '';
    in
    {
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
        NetworkManager-wait-online.enable = false;
      };

      # Systemd OOMd
      # Fedora enables these options by deafult. See the 10-oomd-* files here:
      # https://src.fedoraproject.org/rpms/systemd/tree/acb90c49c42276b06375a66c73673ac3510255
      oomd.enableRootSlice = true;

      # TODO: channels-to-flakes
      tmpfiles.rules = [ "D /nix/var/nix/profiles/per-user/root 755 root root - -" ];
    };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "no";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  time = {
    # Set your time zone.
    timeZone = "Europe/Oslo";
    hardwareClockInLocalTime = true;
  };

  i18n =
    let
      defaultLocale = "en_US.UTF-8";
      no = "nb_NO.UTF-8";
    in
    {
      inherit defaultLocale;
      extraLocaleSettings = {
        LANG = defaultLocale;
        LC_COLLATE = defaultLocale;
        LC_CTYPE = defaultLocale;
        LC_MESSAGES = defaultLocale;

        LC_ADDRESS = no;
        LC_IDENTIFICATION = no;
        LC_MEASUREMENT = no;
        LC_MONETARY = no;
        LC_NAME = no;
        LC_NUMERIC = no;
        LC_PAPER = no;
        LC_TELEPHONE = no;
        LC_TIME = no;
      };
    };
  services = {
    dbus = {
      packages = with pkgs; [
        dconf
        gcr
        udisks2
      ];
      enable = true;
    };
    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
      android-udev-rules
    ];
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
    udisks2.enable = true;
    # profile-sync-daemon
    psd = {
      enable = true;
      resyncTimer = "10m";
    };
  };

  # compress half of the ram to use as swap
  zramSwap = {
    enable = lib.mkDefault false;
    algorithm = "zstd";
  };

  environment.systemPackages = with pkgs; [
    git
    uutils-coreutils-noprefix
    btrfs-progs
    cifs-utils
    appimage-run
  ];

  hardware.ledger.enable = true;

  boot.binfmt.registrations =
    lib.genAttrs
      [
        "appimage"
        "AppImage"
      ]
      (ext: {
        recognitionType = "extension";
        magicOrExtension = ext;
        interpreter = "/run/current-system/sw/bin/appimage-run";
      });

  programs = {
    # allow users to mount fuse filesystems with allow_other
    fuse.userAllowOther = true;

    # help manage android devices via command line
    adb.enable = true;

    # Compatibility layer for dynamically linked binaries that expect FHS
    nix-ld.enable = true;

    java = {
      enable = true;
      package = pkgs.jre;
    };
  };
}
