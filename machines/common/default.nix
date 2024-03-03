{ pkgs }: {
  packages = with pkgs; [
    # Essentials
    exa
    mosh
    ranger
    rclone
    ripgrep

    # Utilities
    curl
    neofetch
    pv
    watch
    tree
    hurl

    # Programming languages
    python3Full
    terraform
    nodejs_20

    # Package managers
    pipx
    yarn
    asdf-vm

    # Cryptography
    age
    magic-wormhole
    openssh
    openssl
    pwgen-secure
    rage

    # Programming tools
    lazygit
    jujutsu
    glab
    gh-dash

    # Language servers
    shellcheck
    vale

    # System and network tools
    bandwhich
    htop
    httpie
    netcat

    # Fonts
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}
