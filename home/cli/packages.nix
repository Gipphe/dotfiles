{ pkgs, ... }:
{
  home.packages = with pkgs; [

    # Make
    gnumake

    # grep replacement
    ripgrep

    # image tooling
    imagemagick

    # video tooling
    ffmpeg-full

    # iamge preview in terminal
    catimg

    # better find
    fd

    # swiss army knife for JSON
    jq

    # used by a lot of things
    unzip

    # mosh

    # rclone

    # probably pre-installed, but included just in case
    gnused
    # probably pre-installed, but included just in case
    gnutar

    # obvious
    curl

    # pv

    # watch

    # run commands when files change
    entr

    # make JSON greppable
    fastgron

    # password manager
    _1password

    # containers
    # docker

    # openssh
    openssl

    # communication
    slack
    discord

    # Programming tools
    glab
    python3Full

    # Libraries
    libgcc
    gcc-unwrapped

    # Language servers
    shellcheck
    vale

    # System and network tools
    # bandwhich
    # httpie
    # netcat

    # Fonts
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}
